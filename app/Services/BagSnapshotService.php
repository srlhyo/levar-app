<?php

namespace App\Services;

use App\Models\Move;
use App\Support\DimensionParser;
use Illuminate\Support\Facades\DB;

class BagSnapshotService
{
    public function refresh(Move $move): void
    {
        $baseQuery = $move->items()->whereNull('deleted_at');

        $totalKg = (float) (clone $baseQuery)->sum('weight_kg');
        $yesKg = (float) (clone $baseQuery)->where('decision', 'yes')->sum('weight_kg');
        $yesItems = (clone $baseQuery)
            ->where('decision', 'yes')
            ->get(['dimensions', 'volume_cm3']);

        $yesDimensions = $yesItems
            ->map(function ($item) {
                $parsed = DimensionParser::parse($item->dimensions);
                if (!$parsed) {
                    return null;
                }

                return [
                    'length' => $parsed['length_cm'],
                    'width' => $parsed['width_cm'],
                    'height' => $parsed['height_cm'],
                    'volume' => $parsed['volume_cm3'],
                ];
            })
            ->filter()
            ->values();

        $pendingCount = (int) (clone $baseQuery)->where('decision', 'pending')->count();
        $decidedCount = (int) (clone $baseQuery)->whereIn('decision', ['yes', 'no'])->count();

        $bagMeta = $move->bags()
            ->with(['items' => fn ($query) => $query->whereNull('deleted_at')])
            ->get()
            ->map(function ($bag) {
                $yesWeight = (float) $bag->items->where('decision', 'yes')->sum('weight_kg');
                $packed = (float) $bag->items->whereNotNull('packed_at')->sum('weight_kg');
                $yesItems = $bag->items->where('decision', 'yes');
                $volume = (float) $yesItems->sum(function ($item) {
                    if (!is_null($item->volume_cm3)) {
                        return (float) $item->volume_cm3;
                    }

                    $parsed = DimensionParser::parse($item->dimensions);

                    return $parsed['volume_cm3'] ?? 0;
                });

                $capacityVolume = DimensionParser::parse($bag->dimensions);

                return [
                    'bag_id' => $bag->id,
                    'name' => $bag->name,
                    'code' => $bag->code,
                    'capacity_kg' => (float) $bag->capacity_kg,
                    'total_kg' => $yesWeight,
                    'yes_kg' => $yesWeight,
                    'packed_kg' => $packed,
                    'remaining_kg' => max((float) $bag->capacity_kg - $yesWeight, 0),
                    'total_volume_cm3' => $volume,
                    'dimensions' => $bag->dimensions,
                    'capacity_volume_cm3' => $capacityVolume['volume_cm3'] ?? null,
                ];
            })
            ->values();

        DB::transaction(function () use ($move, $totalKg, $yesKg, $yesDimensions, $pendingCount, $decidedCount, $bagMeta) {
            $move->snapshot()->updateOrCreate(
                ['move_id' => $move->id],
                [
                    'total_kg' => $totalKg,
                    'yes_kg' => $yesKg,
                    'yes_dimensions' => $yesDimensions,
                    'pending_count' => $pendingCount,
                    'decided_count' => $decidedCount,
                    'meta' => $bagMeta,
                    'updated_at' => now(),
                ]
            );
        });
    }
}
