<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Resources\BagResource;
use App\Http\Resources\ItemResource;
use App\Models\Move;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DecidirController extends Controller
{
    use InteractsWithMoves;

    private const DECK_LIMIT = 40;

    public function __invoke(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $move->load(['bags' => fn ($query) => $query->orderBy('sort_order')]);

        $baseQuery = $move->items()->with(['bag'])->whereNull('deleted_at');

        $deckQuery = (clone $baseQuery)
            ->where('decision', 'undecided')
            ->orderBy('sort_order')
            ->orderBy('id');

        $deck = (clone $deckQuery)->limit(self::DECK_LIMIT)->get();
        $deckCount = (clone $deckQuery)->count();

        $total = (clone $baseQuery)->count();
        $undecided = (clone $baseQuery)->where('decision', 'undecided')->count();
        $pendingBacklog = (clone $baseQuery)->where('decision', 'pending')->count();
        $processed = max($total - $undecided, 0);
        return response()->json([
            'move' => [
                'id' => (string) $move->id,
                'bags' => BagResource::collection($move->bags),
            ],
            'deck' => ItemResource::collection($deck),
            'progress' => [
                'total' => $total,
                'processed' => $processed,
                'pending' => $pendingBacklog,
                'pending_backlog' => $pendingBacklog,
                'undecided' => $undecided,
                'pending_deck' => $deckCount,
                'pending_total' => $pendingBacklog,
            ],
        ]);
    }
}
