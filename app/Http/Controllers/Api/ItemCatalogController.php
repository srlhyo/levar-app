<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Resources\ItemResource;
use App\Models\Item;
use App\Models\Move;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ItemCatalogController extends Controller
{
    use InteractsWithMoves;

    public function index(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $items = $move->items()
            ->with('bag')
            ->whereNull('deleted_at')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'items' => ItemResource::collection($items),
        ]);
    }

    public function store(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $request->merge([
            'weight_kg' => $request->input('weight_kg', $request->input('weight')),
            'volume_cm3' => $request->input('volume_cm3', $request->input('volume')),
        ]);

        $validated = $request->validate([
            'title' => ['required', 'string', 'max:160'],
            'notes' => ['nullable', 'string'],
            'weight_kg' => ['required', 'numeric', 'min:0.01'],
            'volume_cm3' => ['required', 'numeric', 'min:1'],
            'category' => ['nullable', 'string', 'max:80'],
            'fragile' => ['required', 'boolean'],
        ]);

        $item = $move->items()->create([
            'title' => $validated['title'],
            'notes' => $validated['notes'] ?? null,
            'weight_kg' => (float) $validated['weight_kg'],
            'dimensions' => null,
            'volume_cm3' => (float) $validated['volume_cm3'],
            'category' => $validated['category'] ?? null,
            'fragile' => $validated['fragile'],
            'decision' => 'undecided',
            'sort_order' => $this->nextSortOrder($move),
        ]);

        return response()->json([
            'item' => ItemResource::make($item),
        ], 201);
    }

    protected function nextSortOrder(Move $move): int
    {
        $max = (int) $move->items()->max('sort_order');

        return $max + 10;
    }
}
