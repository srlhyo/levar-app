<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Resources\ItemResource;
use App\Models\Item;
use App\Models\Move;
use App\Services\ItemService;
use App\Support\DimensionParser;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ResumoController extends Controller
{
    use InteractsWithMoves;

    public function __construct(private readonly ItemService $itemService)
    {
    }

    public function index(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $baseQuery = $move->items()->with('bag')->whereNull('deleted_at');

        $totals = [
            'total' => (int) (clone $baseQuery)->count(),
            'pending' => (int) (clone $baseQuery)->where('decision', 'pending')->count(),
            'take' => (int) (clone $baseQuery)->where('decision', 'yes')->count(),
            'leave' => (int) (clone $baseQuery)->where('decision', 'no')->count(),
        ];
        $totals['undecided'] = $totals['total'] - ($totals['take'] + $totals['leave'] + $totals['pending']);
        $totals['decided'] = $totals['take'] + $totals['leave'];
        $totals['processed'] = $totals['decided'] + $totals['pending'];
        $totals['remaining'] = max(0, $totals['total'] - $totals['processed']);

        $weightTotal = (float) (clone $baseQuery)->sum('weight_kg');
        $yesWeightTotal = (float) (clone $baseQuery)->where('decision', 'yes')->sum('weight_kg');

        $yesItems = (clone $baseQuery)
            ->where('decision', 'yes')
            ->get(['id', 'dimensions', 'volume_cm3']);

        $yesVolumeCm3 = 0.0;
        $volumeCount = 0;

        foreach ($yesItems as $item) {
            if (!is_null($item->volume_cm3)) {
                $yesVolumeCm3 += (float) $item->volume_cm3;
                if ($item->volume_cm3 > 0) {
                    $volumeCount++;
                }
                continue;
            }

            $parsed = DimensionParser::parse($item->dimensions);
            if ($parsed) {
                $yesVolumeCm3 += $parsed['volume_cm3'];
                $volumeCount++;
            }
        }

        $bagCollection = $move->bags()
            ->with(['items' => fn ($query) => $query->whereNull('deleted_at')])
            ->orderBy('sort_order')
            ->get();

        $bags = $bagCollection->map(function ($bag) {
            $yesWeight = (float) $bag->items->where('decision', 'yes')->sum('weight_kg');
            $packed = (float) $bag->items->whereNotNull('packed_at')->sum('weight_kg');
            $yesItems = $bag->items->where('decision', 'yes');
            $volume = (float) $yesItems->sum(function (Item $item) {
                if (!is_null($item->volume_cm3)) {
                    return (float) $item->volume_cm3;
                }

                $parsed = DimensionParser::parse($item->dimensions);

                return $parsed['volume_cm3'] ?? 0;
            });

            $volumeCount = $yesItems->filter(function (Item $item) {
                if (!is_null($item->volume_cm3) && $item->volume_cm3 > 0) {
                    return true;
                }

                return DimensionParser::parse($item->dimensions) !== null;
            })->count();

            $capacityVolume = DimensionParser::parse($bag->dimensions);

            return [
                'id' => (string) $bag->id,
                'name' => $bag->name,
                'code' => $bag->code,
                'capacity_kg' => (float) $bag->capacity_kg,
                'total_kg' => $yesWeight,
                'yes_kg' => $yesWeight,
                'packed_kg' => $packed,
                'remaining_kg' => max((float) $bag->capacity_kg - $yesWeight, 0),
                'total_volume_cm3' => $volume,
                'dimensions' => $bag->dimensions,
                'volume_count' => $volumeCount,
                'capacity_volume_cm3' => $capacityVolume['volume_cm3'] ?? null,
            ];
        })->values();

        $reservedKgRemaining = (float) $move->reserved_weight_kg;
        $reservedVolumeRemaining = (float) $move->reserved_volume_cm3;

        $epsilon = 1e-4;

        $bags = $bags->map(function (array $bag) use (&$reservedKgRemaining, &$reservedVolumeRemaining, $epsilon) {
            $capacityKg = $bag['capacity_kg'] ?? 0.0;
            $actualKg = $bag['yes_kg'] ?? 0.0;

            $availableKg = max($capacityKg - $actualKg, 0.0);
            $reservedAppliedKg = min($availableKg, max($reservedKgRemaining, 0.0));
            $reservedKgRemaining -= $reservedAppliedKg;

            $effectiveKg = $actualKg + $reservedAppliedKg;
            $remainingKg = max($capacityKg - $effectiveKg, 0.0);

            $capacityVolumeCm3 = $bag['capacity_volume_cm3'] ?? null;
            $volumeUsedCm3 = $bag['total_volume_cm3'] ?? 0.0;

            $reservedAppliedVolumeCm3 = 0.0;
            if (!is_null($capacityVolumeCm3)) {
                $availableVolume = max($capacityVolumeCm3 - $volumeUsedCm3, 0.0);
                $reservedAppliedVolumeCm3 = min($availableVolume, max($reservedVolumeRemaining, 0.0));
                $reservedVolumeRemaining -= $reservedAppliedVolumeCm3;
            }

            $effectiveVolumeCm3 = $volumeUsedCm3 + $reservedAppliedVolumeCm3;
            $remainingVolumeCm3 = !is_null($capacityVolumeCm3)
                ? max($capacityVolumeCm3 - $effectiveVolumeCm3, 0.0)
                : null;

            $weightRatio = $capacityKg > 0 ? $effectiveKg / $capacityKg : 0.0;
            $volumeRatio = (!is_null($capacityVolumeCm3) && $capacityVolumeCm3 > 0)
                ? $effectiveVolumeCm3 / $capacityVolumeCm3
                : 0.0;

            $lockedByWeight = $capacityKg > 0 && $weightRatio >= 1 - $epsilon;
            $lockedByVolume = !is_null($capacityVolumeCm3) && $capacityVolumeCm3 > 0 && $volumeRatio >= 1 - $epsilon;
            $locked = $lockedByWeight || $lockedByVolume;

            $status = 'Normal';
            if ($locked) {
                $status = 'Fechado';
            } elseif ($weightRatio >= 0.9 || $volumeRatio >= 0.9) {
                $status = 'Lotado';
            }

            return array_merge($bag, [
                'reserved_applied_kg' => $reservedAppliedKg,
                'effective_kg' => $effectiveKg,
                'remaining_kg' => $remainingKg,
                'reserved_volume_cm3' => $reservedAppliedVolumeCm3,
                'effective_volume_cm3' => $effectiveVolumeCm3,
                'remaining_volume_cm3' => $remainingVolumeCm3,
                'weight_ratio' => $weightRatio,
                'volume_ratio' => $volumeRatio,
                'locked_by_weight' => $lockedByWeight,
                'locked_by_volume' => $lockedByVolume,
                'locked' => $locked,
                'status' => $status,
            ]);
        });

        $totalCapacityKg = (float) $bagCollection->sum('capacity_kg');
        $yesWeightKg = $yesWeightTotal;
        $remainingCapacityKg = max($totalCapacityKg - (float) $move->reserved_weight_kg - $yesWeightKg, 0);

        $bagCapacityVolumeCm3 = $bagCollection->sum(function ($bag) {
            $dims = DimensionParser::parse($bag->dimensions);

            return $dims['volume_cm3'] ?? 0;
        });
        $reservedVolumeCm3 = (float) $move->reserved_volume_cm3;
        $availableVolumeCm3 = $bagCapacityVolumeCm3 - $reservedVolumeCm3;
        $remainingVolumeCm3 = $availableVolumeCm3 - $yesVolumeCm3;

        $deckCount = (clone $baseQuery)->where('decision', 'undecided')->count();

        $response = [
            'stats' => array_merge($totals, [
                'totalWeight' => $weightTotal,
                'reservedKg' => (float) $move->reserved_weight_kg,
                'pending_total' => $totals['pending'],
                'pending_deck' => $totals['undecided'],
                'totalCapacityKg' => $totalCapacityKg,
                'yesWeightKg' => $yesWeightKg,
                'remainingCapacityKg' => $remainingCapacityKg,
                'volumes' => [
                    'count' => $volumeCount,
                    'volume_cm3' => $yesVolumeCm3,
                    'volume_liters' => $yesVolumeCm3 ? round($yesVolumeCm3 / 1000, 2) : 0,
                    'capacity_cm3' => $bagCapacityVolumeCm3,
                    'capacity_liters' => $bagCapacityVolumeCm3 ? round($bagCapacityVolumeCm3 / 1000, 2) : 0,
                    'reserved_cm3' => $reservedVolumeCm3,
                    'reserved_liters' => $reservedVolumeCm3 ? round($reservedVolumeCm3 / 1000, 2) : 0,
                    'available_cm3' => $availableVolumeCm3,
                    'available_liters' => $availableVolumeCm3 ? round($availableVolumeCm3 / 1000, 2) : 0,
                    'remaining_cm3' => $remainingVolumeCm3,
                    'remaining_liters' => $remainingVolumeCm3 ? round($remainingVolumeCm3 / 1000, 2) : 0,
                    'overflow_cm3' => $remainingVolumeCm3 < 0 ? abs($remainingVolumeCm3) : 0,
                    'overflow_liters' => $remainingVolumeCm3 < 0 ? round(abs($remainingVolumeCm3) / 1000, 2) : 0,
                ],
            ]),
            'bags' => $bags,
            'lists' => [
                'take' => ItemResource::collection((clone $baseQuery)->where('decision', 'yes')->orderBy('sort_order')->get()),
                'pending' => ItemResource::collection((clone $baseQuery)->where('decision', 'pending')->orderBy('sort_order')->get()),
                'undecided' => ItemResource::collection((clone $baseQuery)->where('decision', 'undecided')->orderBy('sort_order')->get()),
                'leave' => ItemResource::collection((clone $baseQuery)->where('decision', 'no')->orderBy('sort_order')->get()),
            ],
            'export_allowed' => $totals['pending'] === 0 && $totals['undecided'] === 0,
        ];

        return response()->json($response);
    }

    public function movePendingToLeave(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $validated = $request->validate([
            'ids' => ['required', 'array', 'min:1'],
            'ids.*' => ['integer', 'distinct'],
        ]);

        $items = Item::whereIn('id', $validated['ids'])->where('move_id', $move->id)->get();

        abort_if($items->isEmpty(), 404, 'Items not found for this move.');

        $this->itemService->movePendingToLeave($move, $items, $request->user());

        return response()->json(['status' => 'ok']);
    }

}
