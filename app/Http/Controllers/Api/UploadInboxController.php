<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Models\ItemMedia;
use App\Models\Move;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UploadInboxController extends Controller
{
    use InteractsWithMoves;

    public function __invoke(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $itemIds = $move->items()->pluck('id');

        $media = ItemMedia::whereIn('item_id', $itemIds)
            ->orderByDesc('created_at')
            ->limit(50)
            ->get()
            ->map(function (ItemMedia $media) {
                return [
                    'id' => (string) $media->id,
                    'name' => basename($media->path),
                    'description' => $media->item?->title,
                    'size' => $this->formatBytes($media->bytes ?? 0),
                    'status' => $media->status,
                    'updatedAt' => optional($media->updated_at)->diffForHumans(),
                ];
            });

        $counts = [
            'queued' => $media->where('status', 'queued')->count(),
            'uploading' => $media->where('status', 'uploading')->count(),
            'done' => $media->where('status', 'done')->count(),
            'error' => $media->where('status', 'error')->count(),
        ];

        return response()->json([
            'queue' => $media,
            'counts' => $counts,
        ]);
    }

    private function formatBytes(int $bytes, int $precision = 1): string
    {
        if ($bytes <= 0) {
            return '0 B';
        }

        $units = ['B', 'KB', 'MB', 'GB', 'TB'];
        $power = (int) floor(log($bytes, 1024));
        $power = min($power, count($units) - 1);

        return number_format($bytes / (1024 ** $power), $precision) . ' ' . $units[$power];
    }
}
