<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Models\Item;
use App\Services\ItemService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ItemRequeueController extends Controller
{
    use InteractsWithMoves;

    public function __construct(private readonly ItemService $itemService)
    {
    }

    public function __invoke(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'ids' => ['required', 'array', 'min:1'],
            'ids.*' => ['integer', 'distinct'],
        ]);

        $items = Item::with('move')
            ->whereIn('id', $validated['ids'])
            ->get();

        abort_if($items->isEmpty(), 404, 'No items found.');

        $move = $items->first()->move;
        $this->authorizeMove($request, $move);

        abort_if($items->contains(fn ($item) => $item->move_id !== $move->id), 422, 'All items must belong to the same move.');

        $this->itemService->requeue($move, $items);

        return response()->json(['status' => 'ok']);
    }
}
