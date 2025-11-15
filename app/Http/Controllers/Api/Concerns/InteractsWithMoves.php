<?php

namespace App\Http\Controllers\Api\Concerns;

use App\Models\Bag;
use App\Models\Item;
use App\Models\Move;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

trait InteractsWithMoves
{
    protected function authorizeMove(Request $request, Move $move): void
    {
        $user = $request->user();

        if (!$user || $user->id !== $move->user_id) {
            abort(Response::HTTP_FORBIDDEN, 'You do not have access to this move.');
        }
    }

    protected function ensureItemBelongsToMove(Item $item, Move $move): void
    {
        if ($item->move_id !== $move->id) {
            abort(Response::HTTP_NOT_FOUND, 'Item not found for this move.');
        }
    }

    protected function authorizeItem(Request $request, Item $item): Move
    {
        $move = $item->move;

        if (!$move) {
            abort(Response::HTTP_NOT_FOUND, 'Move not found for item.');
        }

        $this->authorizeMove($request, $move);

        return $move;
    }

    protected function authorizeBag(Request $request, Bag $bag): Move
    {
        $move = $bag->move;

        if (!$move) {
            abort(Response::HTTP_NOT_FOUND, 'Move not found for bag.');
        }

        $this->authorizeMove($request, $move);

        return $move;
    }
}
