<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Resources\ItemResource;
use App\Models\Item;
use App\Models\Move;
use App\Services\BagSnapshotService;
use App\Support\DimensionParser;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PackController extends Controller
{
    use InteractsWithMoves;

    public function __construct(private readonly BagSnapshotService $snapshotService)
    {
    }

    public function index(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $bags = $move->bags()->orderBy('sort_order')->get();
        $items = $move->items()
            ->with('bag')
            ->whereNull('deleted_at')
            ->where('decision', 'yes')
            ->orderBy('sort_order')
            ->get();

        $bagSummaries = $bags->map(function ($bag) use ($items) {
            $bagItems = $items->where('bag_id', $bag->id);
            $totalWeight = (float) $bagItems->sum('weight_kg');
            $packedWeight = (float) $bagItems->whereNotNull('packed_at')->sum('weight_kg');
            $volumeUsed = (float) $bagItems->sum(function (Item $item) {
                if (!is_null($item->volume_cm3)) {
                    return (float) $item->volume_cm3;
                }

                $parsed = DimensionParser::parse($item->dimensions);

                return $parsed['volume_cm3'] ?? 0;
            });

            $capacityVolume = DimensionParser::parse($bag->dimensions);
            $capacityVolumeCm3 = $capacityVolume['volume_cm3'] ?? null;

            return [
                'id' => (string) $bag->id,
                'name' => $bag->name,
                'code' => $bag->code,
                'capacity_kg' => (float) $bag->capacity_kg,
                'total_kg' => $totalWeight,
                'packed_kg' => $packedWeight,
                'total_volume_cm3' => $volumeUsed,
                'capacity_volume_cm3' => $capacityVolumeCm3,
                'dimensions' => $bag->dimensions,
            ];
        })->values();

        $reservedKgRemaining = max((float) $move->reserved_weight_kg, 0);
        $reservedVolumeRemaining = max((float) $move->reserved_volume_cm3, 0);

        $bagSummaries = $bagSummaries->map(function (array $bag) use (&$reservedKgRemaining, &$reservedVolumeRemaining) {
            $capacityKg = $bag['capacity_kg'] ?? 0;
            $totalKg = $bag['total_kg'] ?? 0;
            $availableKg = max($capacityKg - $totalKg, 0);
            $reservedKgApplied = min($availableKg, $reservedKgRemaining);
            $reservedKgRemaining -= $reservedKgApplied;

            $effectiveKg = $totalKg + $reservedKgApplied;
            $remainingKg = max($capacityKg - $effectiveKg, 0);

            $capacityVolumeCm3 = $bag['capacity_volume_cm3'] ?? null;
            $volumeUsedCm3 = $bag['total_volume_cm3'] ?? 0;
            $reservedVolumeApplied = 0.0;
            if ($capacityVolumeCm3 !== null) {
                $availableVolume = max($capacityVolumeCm3 - $volumeUsedCm3, 0);
                $reservedVolumeApplied = min($availableVolume, $reservedVolumeRemaining);
                $reservedVolumeRemaining -= $reservedVolumeApplied;
            }
            $effectiveVolumeCm3 = $volumeUsedCm3 + $reservedVolumeApplied;
            $remainingVolumeCm3 = $capacityVolumeCm3 !== null
                ? max($capacityVolumeCm3 - $effectiveVolumeCm3, 0)
                : null;

            $weightRatio = $capacityKg > 0 ? $effectiveKg / $capacityKg : 0;
            $volumeRatio = ($capacityVolumeCm3 ?? 0) > 0 ? $effectiveVolumeCm3 / $capacityVolumeCm3 : 0;

            $lockedByWeight = $capacityKg > 0 && $weightRatio >= 1;
            $lockedByVolume = ($capacityVolumeCm3 ?? 0) > 0 && $volumeRatio >= 1;

            return array_merge($bag, [
                'reserved_kg' => $reservedKgApplied,
                'effective_kg' => $effectiveKg,
                'remaining_kg' => $remainingKg,
                'reserved_volume_cm3' => $reservedVolumeApplied,
                'effective_volume_cm3' => $effectiveVolumeCm3,
                'remaining_volume_cm3' => $remainingVolumeCm3,
                'weight_ratio' => $weightRatio,
                'volume_ratio' => $volumeRatio,
                'locked_by_weight' => $lockedByWeight,
                'locked_by_volume' => $lockedByVolume,
                'locked' => $lockedByWeight || $lockedByVolume,
            ]);
        });

        $totalCapacityKg = (float) $bags->sum('capacity_kg');

        return response()->json([
            'items' => ItemResource::collection($items),
            'bags' => $bagSummaries,
            'totals' => [
                'total_capacity' => $totalCapacityKg,
                'reserved_kg' => (float) $move->reserved_weight_kg,
                'reserved_volume_cm3' => (float) $move->reserved_volume_cm3,
            ],
        ]);
    }

    public function assign(Request $request, Item $item): JsonResponse
    {
        $move = $this->authorizeItem($request, $item);

        $data = $request->validate([
            'bag' => ['nullable', 'string', 'max:10'],
        ]);

        $bag = null;
        if (!empty($data['bag'])) {
            $bag = $move->bags()->where('code', $data['bag'])->first();
            abort_if(!$bag, 422, 'Bag not found.');
        }

        $item->bag()->associate($bag);
        $item->save();

        $this->snapshotService->refresh($move);

        return response()->json([
            'item' => ItemResource::make($item->fresh('bag')),
        ]);
    }
}
