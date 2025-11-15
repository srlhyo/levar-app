<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Requests\Resumo\MovePendingToLeaveRequest;
use App\Http\Resources\ItemResource;
use App\Models\Item;
use App\Models\Move;
use App\Services\ItemService;
use App\Services\ResumoService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ResumoController extends Controller
{
    use InteractsWithMoves;

    public function __construct(
        private readonly ItemService $itemService,
        private readonly ResumoService $resumoService,
    ) {
    }

    public function index(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $payload = $this->resumoService->buildPayload($move);
        $lists = $payload['lists'];

        return response()->json([
            'stats' => $payload['stats'],
            'bags' => $payload['bags'],
            'lists' => [
                'take' => ItemResource::collection($lists['take']),
                'pending' => ItemResource::collection($lists['pending']),
                'undecided' => ItemResource::collection($lists['undecided']),
                'leave' => ItemResource::collection($lists['leave']),
            ],
            'export_allowed' => $payload['export_allowed'],
        ]);
    }

    public function movePendingToLeave(MovePendingToLeaveRequest $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $items = Item::whereIn('id', $request->validated('ids'))
            ->where('move_id', $move->id)
            ->get();

        abort_if($items->isEmpty(), 404, 'Items not found for this move.');

        $this->itemService->movePendingToLeave($move, $items, $request->user());

        return response()->json(['status' => 'ok']);
    }

}
