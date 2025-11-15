<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Requests\Pick\UpdateItemPriorityRequest;
use App\Http\Resources\ItemResource;
use App\Models\Item;
use Illuminate\Http\JsonResponse;

class ItemPriorityController extends Controller
{
    use InteractsWithMoves;

    public function update(UpdateItemPriorityRequest $request, Item $item): JsonResponse
    {
        $this->authorizeItem($request, $item);

        $priority = $request->validated('priority');

        $item->priority = $priority ?: null;
        $item->save();

        return response()->json([
            'item' => ItemResource::make($item->fresh('bag')),
        ]);
    }
}
