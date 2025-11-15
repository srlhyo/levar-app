<?php

namespace App\Services;

use App\Models\Bag;
use App\Models\Item;
use App\Models\Move;
use App\Models\DecisionLog;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Collection;
use InvalidArgumentException;

class ItemService
{
    public function __construct(private readonly BagSnapshotService $snapshotService)
    {
    }

    public function decide(
        Item $item,
        string $decision,
        ?Bag $bag = null,
        ?User $user = null,
        array $context = [],
        bool $clearBag = false
    ): Item
    {
        if (!in_array($decision, ['undecided', 'pending', 'yes', 'no'], true)) {
            throw new InvalidArgumentException('Invalid decision value.');
        }

        return DB::transaction(function () use ($item, $decision, $bag, $user, $context, $clearBag) {
            $move = $item->move;
            $from = $item->decision;

            $item->decision = $decision;

            $this->syncBagAssignment($item, $decision, $bag, $clearBag);
            $item->packed_at = $decision === 'yes' ? $item->packed_at : null;

            $item->save();

            DecisionLog::create([
                'item_id' => $item->id,
                'from_decision' => $from,
                'to_decision' => $decision,
                'context' => $context,
                'decided_by' => $user?->id,
                'created_at' => now(),
            ]);

            $this->snapshotService->refresh($move);

            return $item->fresh(['bag']);
        });
    }

    public function requeue(Move $move, Collection $items): void
    {
        if ($items->isEmpty()) {
            return;
        }

        DB::transaction(function () use ($move, $items) {
            $minSort = $move->items()
                ->whereNull('deleted_at')
                ->where('decision', 'undecided')
                ->min('sort_order');

            $anchor = is_null($minSort) ? 0 : (int) $minSort;

            $counter = 1;
            foreach ($items as $item) {
                if ($item->move_id !== $move->id) {
                    continue;
                }

                if ($item->decision !== 'undecided') {
                    $item->decision = 'undecided';
                    $item->bag()->dissociate();
                    $item->packed_at = null;
                }

                $item->sort_order = $anchor - $counter;
                $item->save();
                $counter++;
            }

            $this->snapshotService->refresh($move);
        });
    }

    public function markPacked(Move $move, Collection $items, bool $packed): void
    {
        if ($items->isEmpty()) {
            return;
        }

        DB::transaction(function () use ($move, $items, $packed) {
            $timestamp = $packed ? now() : null;
            foreach ($items as $item) {
                if ($item->move_id !== $move->id) {
                    continue;
                }

                $item->packed_at = $timestamp;
                $item->save();
            }

            $this->snapshotService->refresh($move);
        });
    }

    public function movePendingToLeave(Move $move, Collection $items, ?User $user = null): void
    {
        DB::transaction(function () use ($move, $items, $user) {
            foreach ($items as $item) {
                if ($item->move_id !== $move->id) {
                    continue;
                }

                $from = $item->decision;
                $item->decision = 'no';
                $item->packed_at = null;
                $item->save();

                DecisionLog::create([
                    'item_id' => $item->id,
                    'from_decision' => $from,
                    'to_decision' => 'no',
                    'context' => ['action' => 'pending_to_leave'],
                    'decided_by' => $user?->id,
                    'created_at' => now(),
                ]);
            }

            $this->snapshotService->refresh($move);
        });
    }

    private function syncBagAssignment(Item $item, string $decision, ?Bag $bag, bool $clearBag): void
    {
        $shouldClear = $decision !== 'yes' || $clearBag;

        if ($shouldClear) {
            $item->bag()->dissociate();
            return;
        }

        if ($bag === null) {
            return;
        }

        if ($bag->move_id !== $item->move_id) {
            throw new InvalidArgumentException('Bag does not belong to the same move.');
        }

        $item->bag()->associate($bag);
    }

}
