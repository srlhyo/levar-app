<?php

namespace App\Http\Controllers\Api\Concerns;

use App\Models\Item;
use App\Models\Move;
use Illuminate\Http\Request;

trait InteractsWithMoves
{
    protected function authorizeMove(Request $request, Move $move): void
    {
        if ($request->user()->id !== $move->user_id) {
            abort(403, 'You do not have access to this move.');
        }
    }

    protected function ensureItemBelongsToMove(Item $item, Move $move): void
    {
        if ($item->move_id !== $move->id) {
            abort(404, 'Item not found for this move.');
        }
    }

    protected function authorizeItem(Request $request, Item $item): Move
    {
        $move = $item->move;

        if (!$move) {
            abort(404, 'Move not found for item.');
        }

        $this->authorizeMove($request, $move);

        return $move;
    }
}
