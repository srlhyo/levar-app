<?php

namespace App\Services;

use App\Models\Bag;
use App\Models\Move;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\DB;

class MoveConfigService
{
    public function __construct(private readonly BagSnapshotService $bagSnapshotService)
    {
    }

    public function update(Move $move, array $payload): void
    {
        $reservedVolumeCm3 = isset($payload['reserved_volume_liters'])
            ? round((float) $payload['reserved_volume_liters'] * 1000, 2)
            : 0;

        DB::transaction(function () use ($move, $payload, $reservedVolumeCm3) {
            $move->update([
                'reserved_weight_kg' => (float) $payload['reserved_kg'],
                'reserved_volume_cm3' => $reservedVolumeCm3,
            ]);

            $incoming = collect($payload['bags'] ?? [])
                ->map(fn ($bag, $index) => $this->normalizeBagPayload($bag, $index));

            $existing = $move->bags()->get()->keyBy('id');
            $processed = [];

            foreach ($incoming as $bagData) {
                if ($bagData['id'] && $existing->has($bagData['id'])) {
                    /** @var Bag $bag */
                    $bag = $existing[$bagData['id']];
                    $bag->update($bagData);
                    $processed[] = $bag->id;
                    continue;
                }

                $bag = $move->bags()->create($bagData);
                $processed[] = $bag->id;
            }

            $move->bags()
                ->whereNotIn('id', $processed)
                ->get()
                ->each(function (Bag $bag) {
                    $bag->items()->update(['bag_id' => null]);
                    $bag->delete();
                });
        });

        $this->bagSnapshotService->refresh($move->fresh('bags'));
    }

    private function normalizeBagPayload(array $bag, int $index): array
    {
        return [
            'id' => $bag['id'] ?? null,
            'name' => trim((string) ($bag['name'] ?? '')),
            'code' => $bag['code'] ? trim((string) $bag['code']) : null,
            'capacity_kg' => (float) ($bag['capacity_kg'] ?? 0),
            'dimensions' => $bag['dimensions'] ? trim((string) $bag['dimensions']) : null,
            'sort_order' => $index,
        ];
    }
}
