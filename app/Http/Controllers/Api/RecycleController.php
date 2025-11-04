<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Models\Item;
use App\Models\ItemMedia;
use App\Models\Move;
use App\Services\BagSnapshotService;
use App\Support\DimensionParser;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class RecycleController extends Controller
{
    use InteractsWithMoves;

    public function __construct(private readonly BagSnapshotService $snapshotService)
    {
    }

    public function index(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $now = now();
        $items = Item::onlyTrashed()
            ->where('move_id', $move->id)
            ->orderByDesc('deleted_at')
            ->get()
            ->map(function (Item $item) use ($now) {
                $deletedAt = $item->deleted_at ?? $now;
                $daysAgo = $deletedAt->diffInDays($now);
                $daysLeft = max(0, 60 - $daysAgo);

                $volumeCm3 = !is_null($item->volume_cm3)
                    ? (float) $item->volume_cm3
                    : optional(DimensionParser::parse($item->dimensions))['volume_cm3'] ?? null;

                return [
                    'id' => (string) $item->id,
                    'title' => $item->title,
                    'name' => $item->title,
                    'location' => $item->location_hint,
                    'weight' => $item->weight_kg !== null ? (float) $item->weight_kg : null,
                    'volume_cm3' => $volumeCm3,
                    'volume_liters' => $volumeCm3 !== null ? round($volumeCm3 / 1000, 2) : null,
                    'deletedAt' => $deletedAt->diffForHumans(),
                    'daysLeft' => $daysLeft,
                ];
            });

        return response()->json([
            'items' => $items,
        ]);
    }

    public function softDelete(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'ids' => ['required', 'array', 'min:1'],
            'ids.*' => ['integer', 'distinct'],
        ]);

        $items = Item::with('move')->whereIn('id', $validated['ids'])->get();
        abort_if($items->isEmpty(), 404, 'Items not found.');

        $move = $items->first()->move;
        $this->authorizeMove($request, $move);
        abort_if($items->contains(fn ($item) => $item->move_id !== $move->id), 422, 'Items must belong to the same move.');

        Item::whereIn('id', $validated['ids'])->delete();
        $this->snapshotService->refresh($move);

        return response()->json(['status' => 'ok']);
    }

    public function restore(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'ids' => ['required', 'array', 'min:1'],
            'ids.*' => ['integer', 'distinct'],
        ]);

        $items = Item::onlyTrashed()->with('move')->whereIn('id', $validated['ids'])->get();
        abort_if($items->isEmpty(), 404, 'Items not found.');

        $move = $items->first()->move;
        $this->authorizeMove($request, $move);
        abort_if($items->contains(fn ($item) => $item->move_id !== $move->id), 422, 'Items must belong to the same move.');

        Item::onlyTrashed()->whereIn('id', $validated['ids'])->restore();
        $this->snapshotService->refresh($move);

        return response()->json(['status' => 'ok']);
    }

    public function destroy(Request $request, Item $item): JsonResponse
    {
        $move = $this->authorizeItem($request, $item);

        $item->load('media');
        $this->deleteMediaFiles($item->media);
        $item->forceDelete();
        $this->snapshotService->refresh($move);

        return response()->json(['status' => 'ok']);
    }

    protected function deleteMediaFiles($mediaCollection): void
    {
        $mediaCollection->each(function (ItemMedia $media) {
            $disk = $media->disk;
            $paths = array_filter([$media->path, $media->thumb_path]);
            Storage::disk($disk)->delete($paths);
            $media->delete();
        });
    }
}
