<?php

namespace App\Services;

use App\Models\Bag;
use App\Models\DecisionLog;
use App\Models\Item;
use App\Models\Move;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class MoveOnboardingService
{
    private ?bool $priorityColumnExists = null;

    public function __construct(
        private readonly BagSnapshotService $snapshotService,
    ) {
    }

    private function makeDimensions(): array
    {
        $length = fake()->numberBetween(20, 90);
        $width = fake()->numberBetween(15, 60);
        $height = fake()->numberBetween(10, 40);

        return [
            'string' => sprintf('%d × %d × %d cm', $length, $width, $height),
            'volume_cm3' => $length * $width * $height,
        ];
    }

    public function bootstrapDemoData(Move $move, int $itemCount = 45): void
    {
        DB::transaction(function () use ($move, $itemCount) {
            $bags = $this->ensureDefaultBags($move);

            if ($move->items()->exists()) {
                $this->snapshotService->refresh($move);

                return;
            }

            $service = $this;

            $items = Item::factory()
                ->forMove($move)
                ->count($itemCount)
                ->state(function () use ($service) {
                    $decision = fake()->randomElement([
                        'undecided',
                        'undecided',
                        'pending',
                        'yes',
                        'no',
                    ]);

                    $dimensions = $service->makeDimensions();

                    $state = [
                        'decision' => $decision,
                        'dimensions' => $dimensions['string'],
                        'volume_cm3' => $dimensions['volume_cm3'],
                    ];

                    if ($service->itemsHavePriorityColumn()) {
                        $state['priority'] = fake()->randomElement(['alta', 'media', 'baixa']);
                    }

                    return $state;
                })
                ->create();

            $this->applyBagAssignments($items, $bags);
            $this->attachPlaceholderMedia($items);
            $this->snapshotService->refresh($move);
        });
    }

    /**
     * @return Collection<int, Bag>
     */
    private function ensureDefaultBags(Move $move): Collection
    {
        $existing = $move->bags()->orderBy('sort_order')->get();

        if ($existing->isNotEmpty()) {
            return $existing;
        }

        $move->bags()->createMany([
            ['name' => 'Mala A', 'code' => 'A', 'capacity_kg' => 23, 'dimensions' => '78 × 50 × 30 cm', 'sort_order' => 0],
            ['name' => 'Mala B', 'code' => 'B', 'capacity_kg' => 23, 'dimensions' => '75 × 48 × 28 cm', 'sort_order' => 1],
        ]);

        return $move->bags()->orderBy('sort_order')->get();
    }

    /**
     * @param Collection<int, Item> $items
     * @param Collection<int, Bag> $bags
     */
    private function applyBagAssignments(Collection $items, Collection $bags): void
    {
        $items->each(function (Item $item) use ($bags) {
            if ($bags->isNotEmpty() && $item->decision === 'yes') {
                /** @var Bag $bag */
                $bag = $bags->random();
                $item->bag()->associate($bag);
                if (!$item->packed_at && fake()->boolean(60)) {
                    $item->packed_at = now()->subDays(fake()->numberBetween(0, 5));
                }
            } elseif ($bags->isNotEmpty() && $item->decision === 'no' && fake()->boolean(20)) {
                /** @var Bag $bag */
                $bag = $bags->random();
                $item->bag()->associate($bag);
            }

            $item->sort_order = match ($item->decision) {
                'undecided' => fake()->numberBetween(-200, 200),
                'pending' => fake()->numberBetween(200, 600),
                default => fake()->numberBetween(600, 1200),
            };

            $item->save();

            $logCount = fake()->numberBetween(1, 3);
            $decisionSequence = collect(['undecided', 'pending', 'yes', 'no'])
                ->shuffle()
                ->take($logCount + 1)
                ->values();

            for ($i = 0; $i < $logCount; $i++) {
                DecisionLog::factory()->create([
                    'item_id' => $item->id,
                    'from_decision' => $decisionSequence[$i] ?? null,
                    'to_decision' => $decisionSequence[$i + 1] ?? $item->decision,
                    'created_at' => now()->subDays(fake()->numberBetween(1, 10))->addMinutes($i * 5),
                ]);
            }
        });
    }

    /**
     * @param Collection<int, Item> $items
     */
    private function attachPlaceholderMedia(Collection $items): void
    {
        $disk = config('filesystems.default', 'public');
        $seedImage = resource_path('seed-images/placeholder.png');

        if (!is_file($seedImage)) {
            return;
        }

        $contents = file_get_contents($seedImage);

        $items
            ->filter(fn (Item $item) => fake()->boolean(30))
            ->each(function (Item $item) use ($disk, $contents) {
                $uuid = (string) Str::uuid();
                $originalPath = "items/{$uuid}.png";
                $thumbPath = "items/thumbs/{$uuid}.png";

                Storage::disk($disk)->put($originalPath, $contents);
                Storage::disk($disk)->put($thumbPath, $contents);

                $media = $item->media()->create([
                    'disk' => $disk,
                    'path' => $originalPath,
                    'thumb_path' => $thumbPath,
                    'status' => 'done',
                    'bytes' => strlen($contents),
                    'width' => 1,
                    'height' => 1,
                    'mime' => 'image/png',
                ]);

                $item->update([
                    'photo_url' => Storage::disk($disk)->url($media->path),
                    'thumbnail_url' => Storage::disk($disk)->url($media->thumb_path),
                ]);
            });
    }
    private function itemsHavePriorityColumn(): bool
    {
        if ($this->priorityColumnExists !== null) {
            return $this->priorityColumnExists;
        }

        return $this->priorityColumnExists = Schema::hasColumn('items', 'priority');
    }
}
