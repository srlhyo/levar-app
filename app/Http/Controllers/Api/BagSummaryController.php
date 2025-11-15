<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Resources\ItemResource;
use App\Models\Bag;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BagSummaryController extends Controller
{
    use InteractsWithMoves;

    public function show(Request $request, Bag $bag): JsonResponse
    {
        $move = $this->authorizeBag($request, $bag);

        $bag->load(['items' => function ($query) {
            $query->whereNull('deleted_at')->where('decision', 'yes')->with('bag');
        }]);

        $items = $bag->items->sortBy('sort_order')->values();

        $totalWeight = (float) $items->sum('weight_kg');
        $packedCount = (int) $items->whereNotNull('packed_at')->count();

        return response()->json([
            'bag' => [
                'id' => (string) $bag->id,
                'name' => $bag->name,
                'code' => $bag->code,
                'dimensions' => $bag->dimensions,
                'capacity_kg' => (float) $bag->capacity_kg,
                'notes' => $bag->notes,
                'checklist' => $bag->checklist ?? [],
                'totals' => [
                    'items' => $items->count(),
                    'packed' => $packedCount,
                    'weight_kg' => $totalWeight,
                ],
            ],
            'items' => ItemResource::collection($items),
        ]);
    }
}
