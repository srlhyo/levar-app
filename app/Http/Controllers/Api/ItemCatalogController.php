<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Requests\Catalog\StoreCatalogItemRequest;
use App\Http\Resources\ItemResource;
use App\Models\Item;
use App\Models\Move;
use App\Services\CatalogItemService;
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

    public function store(StoreCatalogItemRequest $request, Move $move, CatalogItemService $service): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $item = $service->create($move, $request->validated());

        return response()->json([
            'item' => ItemResource::make($item),
        ], 201);
    }
}
