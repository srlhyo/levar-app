<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Requests\Pick\AssignBagRequest;
use App\Http\Resources\ItemResource;
use App\Models\Item;
use App\Models\Move;
use App\Services\BagActivityService;
use App\Services\BagSnapshotService;
use App\Services\PackService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PackController extends Controller
{
    use InteractsWithMoves;

    public function __construct(
        private readonly BagSnapshotService $snapshotService,
        private readonly PackService $packService,
        private readonly BagActivityService $bagActivityService,
    ) {
    }

    public function index(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $payload = $this->packService->buildPayload($move);

        return response()->json([
            'items' => ItemResource::collection($payload['items']),
            'bags' => $payload['bags'],
            'totals' => $payload['totals'],
        ]);
    }

    public function assign(AssignBagRequest $request, Item $item): JsonResponse
    {
        $move = $this->authorizeItem($request, $item);

        $bagCode = $request->validated('bag');

        $bag = null;
        if (!empty($bagCode)) {
            $bag = $move->bags()
                ->where('code', $bagCode)
                ->orWhere('id', $bagCode)
                ->first();
            abort_if(!$bag, 422, 'Bag not found.');
        }

        $item->loadMissing('bag');
        $previousBag = $item->bag;
        $item->bag()->associate($bag);
        $item->save();

        $this->snapshotService->refresh($move);
        $this->bagActivityService->logAssignment($item->fresh('bag'), $previousBag, $bag, $request->user());

        return response()->json([
            'item' => ItemResource::make($item->fresh('bag')),
        ]);
    }
}
