<?php

namespace App\Services;

use App\Models\Item;
use App\Models\Move;
use App\Support\ChecklistSerializer;
use App\Support\DimensionParser;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection as EloquentCollection;
use Illuminate\Support\Collection;

class ResumoService
{
    public function buildPayload(Move $move): array
    {
        $baseQuery = Item::query()
            ->with('bag')
            ->where('move_id', $move->id)
            ->whereNull('deleted_at');

        $totals = $this->buildCounts($baseQuery);
        $weightTotal = (float) (clone $baseQuery)->sum('weight_kg');

        $yesQuery = (clone $baseQuery)->where('decision', 'yes');
        $yesWeightKg = (float) $yesQuery->sum('weight_kg');
        $yesItems = $yesQuery->get(['id', 'dimensions', 'volume_cm3']);
        $volumeMeta = $this->calculateVolumeMeta($yesItems);

        $bagCollection = $move->bags()
            ->with(['items' => fn ($query) => $query->whereNull('deleted_at')])
            ->orderBy('sort_order')
            ->get();

        $bags = $this->applyReservedToBags(
            $this->mapBags($bagCollection),
            (float) $move->reserved_weight_kg,
            (float) $move->reserved_volume_cm3,
        );

        $totalCapacityKg = (float) $bagCollection->sum('capacity_kg');
        $remainingCapacityKg = max($totalCapacityKg - (float) $move->reserved_weight_kg - $yesWeightKg, 0);

        $bagCapacityVolumeCm3 = $bagCollection->sum(static function ($bag) {
            $parsed = DimensionParser::parse($bag->dimensions);

            return $parsed['volume_cm3'] ?? 0;
        });

        $reservedVolumeCm3 = (float) $move->reserved_volume_cm3;
        $availableVolumeCm3 = $bagCapacityVolumeCm3 - $reservedVolumeCm3;
        $remainingVolumeCm3 = $availableVolumeCm3 - $volumeMeta['volume_cm3'];

        $lists = $this->buildLists($baseQuery);

        return [
            'stats' => array_merge($totals, [
                'totalWeight' => $weightTotal,
                'reservedKg' => (float) $move->reserved_weight_kg,
                'pending_total' => $totals['pending'],
                'pending_deck' => $totals['undecided'],
                'totalCapacityKg' => $totalCapacityKg,
                'yesWeightKg' => $yesWeightKg,
                'remainingCapacityKg' => $remainingCapacityKg,
                'volumes' => [
                    'count' => $volumeMeta['count'],
                    'volume_cm3' => $volumeMeta['volume_cm3'],
                    'volume_liters' => $volumeMeta['volume_cm3'] ? round($volumeMeta['volume_cm3'] / 1000, 2) : 0,
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
            'bags' => $bags->values()->all(),
            'lists' => $lists,
            'export_allowed' => $totals['pending'] === 0 && $totals['undecided'] === 0,
        ];
    }

    /**
     * @return array<string, \Illuminate\Support\Collection<Item>>
     */
    protected function buildLists(Builder $query): array
    {
        return [
            'take' => (clone $query)->where('decision', 'yes')->orderBy('sort_order')->get(),
            'pending' => (clone $query)->where('decision', 'pending')->orderBy('sort_order')->get(),
            'undecided' => (clone $query)->where('decision', 'undecided')->orderBy('sort_order')->get(),
            'leave' => (clone $query)->where('decision', 'no')->orderBy('sort_order')->get(),
        ];
    }

    protected function buildCounts(Builder $query): array
    {
        $total = (int) (clone $query)->count();
        $grouped = (clone $query)
            ->selectRaw('decision, COUNT(*) as aggregate')
            ->groupBy('decision')
            ->pluck('aggregate', 'decision')
            ->map(static fn ($value) => (int) $value);

        $pending = (int) ($grouped['pending'] ?? 0);
        $take = (int) ($grouped['yes'] ?? 0);
        $leave = (int) ($grouped['no'] ?? 0);
        $undecided = (int) ($grouped['undecided'] ?? max($total - ($take + $leave + $pending), 0));

        $decided = $take + $leave;
        $processed = $decided + $pending;

        return [
            'total' => $total,
            'pending' => $pending,
            'take' => $take,
            'leave' => $leave,
            'undecided' => $undecided,
            'decided' => $decided,
            'processed' => $processed,
            'remaining' => max(0, $total - $processed),
        ];
    }

    protected function calculateVolumeMeta(Collection $items): array
    {
        $volumeCm3 = 0.0;
        $count = 0;

        foreach ($items as $item) {
            if (!is_null($item->volume_cm3)) {
                $volumeCm3 += (float) $item->volume_cm3;
                if ($item->volume_cm3 > 0) {
                    $count++;
                }
                continue;
            }

            $parsed = DimensionParser::parse($item->dimensions);
            if ($parsed && ($parsed['volume_cm3'] ?? 0) > 0) {
                $volumeCm3 += $parsed['volume_cm3'];
                $count++;
            }
        }

        return [
            'volume_cm3' => $volumeCm3,
            'count' => $count,
        ];
    }

    protected function mapBags(EloquentCollection $bagCollection): EloquentCollection
    {
        $mapped = $bagCollection->map(function ($bag) {
            $yesItems = $bag->items->where('decision', 'yes');
            $yesWeight = (float) $yesItems->sum('weight_kg');
            $packed = (float) $bag->items->whereNotNull('packed_at')->sum('weight_kg');
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
                'notes' => $bag->notes,
                'checklist' => ChecklistSerializer::normalize($bag->checklist ?? []),
            ];
        })->values();

        return new EloquentCollection($mapped->all());
    }

    protected function applyReservedToBags(Collection $bags, float $reservedKg, float $reservedVolumeCm3): Collection
    {
        $epsilon = 1e-4;

        return $bags->map(function (array $bag) use (&$reservedKg, &$reservedVolumeCm3, $epsilon) {
            $capacityKg = $bag['capacity_kg'] ?? 0.0;
            $actualKg = $bag['yes_kg'] ?? 0.0;

            $availableKg = max($capacityKg - $actualKg, 0.0);
            $reservedAppliedKg = min($availableKg, max($reservedKg, 0.0));
            $reservedKg -= $reservedAppliedKg;

            $effectiveKg = $actualKg + $reservedAppliedKg;
            $remainingKg = max($capacityKg - $effectiveKg, 0.0);

            $capacityVolumeCm3 = $bag['capacity_volume_cm3'] ?? null;
            $volumeUsedCm3 = $bag['total_volume_cm3'] ?? 0.0;

            $reservedAppliedVolumeCm3 = 0.0;
            if (!is_null($capacityVolumeCm3)) {
                $availableVolume = max($capacityVolumeCm3 - $volumeUsedCm3, 0.0);
                $reservedAppliedVolumeCm3 = min($availableVolume, max($reservedVolumeCm3, 0.0));
                $reservedVolumeCm3 -= $reservedAppliedVolumeCm3;
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
    }
}
