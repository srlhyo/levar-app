<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Models\Move;
use Illuminate\Http\Request;

class ExportController extends Controller
{
    use InteractsWithMoves;

    public function __invoke(Request $request, Move $move)
    {
        $this->authorizeMove($request, $move);

        $items = $move->items()
            ->with('bag')
            ->whereNull('deleted_at')
            ->where('decision', 'yes')
            ->orderBy('sort_order')
            ->get();

        $filename = 'move-' . $move->id . '-items.csv';

        return response()->streamDownload(function () use ($items) {
            $handle = fopen('php://output', 'w');
            fputcsv($handle, ['id', 'title', 'weight_kg', 'bag', 'packed_at', 'photo_url']);

            foreach ($items as $item) {
                fputcsv($handle, [
                    $item->id,
                    $item->title,
                    $item->weight_kg,
                    optional($item->bag)->code,
                    optional($item->packed_at)?->toDateTimeString(),
                    $item->photo_url,
                ]);
            }

            fclose($handle);
        }, $filename, [
            'Content-Type' => 'text/csv',
        ]);
    }
}
