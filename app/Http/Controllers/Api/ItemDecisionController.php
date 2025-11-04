<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Resources\ItemResource;
use App\Models\Item;
use App\Services\ItemService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ItemDecisionController extends Controller
{
    use InteractsWithMoves;

    public function __construct(private readonly ItemService $itemService)
    {
    }

    public function store(Request $request, Item $item): JsonResponse
    {
        $move = $this->authorizeItem($request, $item);

        $validated = $request->validate([
            'decision' => ['required', Rule::in(['undecided', 'pending', 'yes', 'no'])],
            'bag' => ['nullable', 'string', 'max:10'],
        ]);

        $bag = null;
        $clearBag = false;

        if ($request->has('bag') && empty($validated['bag'])) {
            $clearBag = true;
        }

        if (!empty($validated['bag'])) {
            $bag = $move->bags()->where('code', $validated['bag'])->first();
            abort_if(!$bag, 422, 'Bag not found.');
            $clearBag = false;
        }

        $updated = $this->itemService->decide(
            $item,
            $validated['decision'],
            $bag,
            $request->user(),
            ['endpoint' => 'api.items.decidir'],
            $clearBag
        );

        return response()->json([
            'item' => ItemResource::make($updated->load('bag')),
        ]);
    }
}
