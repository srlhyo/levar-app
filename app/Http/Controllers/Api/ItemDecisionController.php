<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Requests\ItemDecisionRequest;
use App\Http\Resources\ItemResource;
use App\Models\Bag;
use App\Models\Item;
use App\Models\Move;
use App\Services\ItemService;
use Illuminate\Http\JsonResponse;
use Symfony\Component\HttpFoundation\Response;

class ItemDecisionController extends Controller
{
    use InteractsWithMoves;

    public function __construct(private readonly ItemService $itemService)
    {
    }

    public function store(ItemDecisionRequest $request, Item $item): JsonResponse
    {
        $move = $this->authorizeItem($request, $item);
        $data = $request->validated();

        $bag = $this->determineBag($move, $data['bag'] ?? null);
        $clearBag = $request->has('bag') && empty($data['bag']);

        $updated = $this->itemService->decide(
            $item->loadMissing('bag'),
            $data['decision'],
            $bag,
            $request->user(),
            ['endpoint' => 'api.items.decidir'],
            $clearBag
        );

        return response()->json([
            'item' => ItemResource::make($updated->load('bag')),
        ]);
    }

    private function determineBag(Move $move, ?string $code): ?Bag
    {
        if (!$code) {
            return null;
        }

        $bag = $move->bags()->where('code', $code)->first();
        abort_if(!$bag, Response::HTTP_UNPROCESSABLE_ENTITY, 'Bag not found.');

        return $bag;
    }
}
