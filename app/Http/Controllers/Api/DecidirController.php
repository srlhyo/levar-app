<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Resources\BagResource;
use App\Http\Resources\ItemResource;
use App\Models\Move;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DecidirController extends Controller
{
    use InteractsWithMoves;

    private const DECK_LIMIT = 40;

    public function __invoke(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $move->setRelation(
            'bags',
            $move->bags()
                ->orderBy('sort_order')
                ->get()
        );

        $deckQuery = $this->deckQuery($move);
        $deck = (clone $deckQuery)->limit(self::DECK_LIMIT)->get();
        $deckCount = (clone $deckQuery)->count();

        $progress = $this->buildProgress($move);
        $progress['pending_deck'] = $deckCount;

        return response()->json([
            'move' => [
                'id' => (string) $move->id,
                'bags' => BagResource::collection($move->bags),
            ],
            'deck' => ItemResource::collection($deck),
            'progress' => $progress,
        ]);
    }

    private function deckQuery(Move $move): HasMany
    {
        return $move->items()
            ->with('bag')
            ->whereNull('deleted_at')
            ->where('decision', 'undecided')
            ->orderBy('sort_order')
            ->orderBy('id');
    }

    /**
     * @return array<string, int>
     */
    private function buildProgress(Move $move): array
    {
        $base = $this->baseItemsQuery($move);

        $total = (clone $base)->count();
        $undecided = (clone $base)->where('decision', 'undecided')->count();
        $pendingBacklog = (clone $base)->where('decision', 'pending')->count();

        return [
            'total' => $total,
            'processed' => max($total - $undecided, 0),
            'pending' => $pendingBacklog,
            'pending_backlog' => $pendingBacklog,
            'undecided' => $undecided,
            'pending_total' => $pendingBacklog,
        ];
    }

    private function baseItemsQuery(Move $move): HasMany
    {
        return $move->items()->whereNull('deleted_at');
    }
}
