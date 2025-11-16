<?php

namespace App\Services;

use App\Models\Bag;
use App\Models\BagActivityLog;
use App\Models\Item;
use App\Models\Move;
use App\Models\User;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Schema;

class BagActivityService
{
    public function logAssignment(Item $item, ?Bag $fromBag, ?Bag $toBag, ?User $user = null): void
    {
        $move = $item->move ?? Move::find($item->move_id);
        if (!$move) {
            return;
        }

        if ($fromBag && (!$toBag || $fromBag->id !== ($toBag->id ?? null))) {
            $this->createLog(
                move: $move,
                bag: $fromBag,
                item: $item,
                user: $user,
                action: 'removed',
                meta: [
                    'item_title' => $item->title ?? $item->name,
                    'weight_kg' => $item->weight_kg,
                    'to_bag_code' => $toBag?->code,
                    'to_bag_name' => $toBag?->name,
                ],
            );
        }

        if ($toBag && (!$fromBag || $fromBag->id !== $toBag->id)) {
            $this->createLog(
                move: $move,
                bag: $toBag,
                item: $item,
                user: $user,
                action: 'added',
                meta: [
                    'item_title' => $item->title ?? $item->name,
                    'weight_kg' => $item->weight_kg,
                    'from_bag_code' => $fromBag?->code,
                    'from_bag_name' => $fromBag?->name,
                ],
            );
        }
    }

    public function logNotesUpdate(Bag $bag, ?User $user = null): void
    {
        $move = $bag->move;
        if (!$move) {
            return;
        }

        $this->createLog(
            move: $move,
            bag: $bag,
            item: null,
            user: $user,
            action: 'notes_updated',
            meta: [
                'has_notes' => trim((string) $bag->notes) !== '',
                'checklist_count' => is_array($bag->checklist) ? count($bag->checklist) : 0,
            ],
        );
    }

    protected function createLog(Move $move, ?Bag $bag, ?Item $item, ?User $user, string $action, array $meta = []): void
    {
        if (!Schema::hasTable('bag_activity_logs')) {
            return;
        }

        BagActivityLog::create([
            'move_id' => $move->id,
            'bag_id' => $bag?->id,
            'item_id' => $item?->id,
            'user_id' => $user?->id,
            'action' => $action,
            'meta' => $meta,
        ]);
    }
}
