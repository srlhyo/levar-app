<?php

namespace App\Services;

use App\Models\BagActivityLog;
use App\Models\Item;
use App\Models\Move;
use App\Support\ChecklistSerializer;
use App\Support\DimensionParser;
use Illuminate\Database\Eloquent\Collection as EloquentCollection;

class PackService
{
    public function buildPayload(Move $move): array
    {
        $items = Item::query()
            ->with('bag')
            ->where('move_id', $move->id)
            ->whereNull('deleted_at')
            ->where('decision', 'yes')
            ->orderBy('sort_order')
            ->get();

        $bags = $move->bags()
            ->with(['items' => fn ($query) => $query
                ->whereNull('deleted_at')
                ->where('decision', 'yes')])
            ->orderBy('sort_order')
            ->get();

        $bagSummaries = $this->buildBagSummaries($bags);

        $this->applyReservedCapacity(
            $bagSummaries,
            (float) $move->reserved_weight_kg,
            (float) $move->reserved_volume_cm3,
        );

        $this->attachRecentHistory($bagSummaries, $move);

        return [
            'items' => $items,
            'bags' => $bagSummaries->values()->all(),
            'totals' => [
                'total_capacity' => (float) $bags->sum('capacity_kg'),
                'reserved_kg' => (float) $move->reserved_weight_kg,
                'reserved_volume_cm3' => (float) $move->reserved_volume_cm3,
            ],
        ];
    }

    protected function buildBagSummaries(EloquentCollection $bags): EloquentCollection
    {
        $summary = $bags->map(function ($bag) {
            $items = $bag->items ?? collect();
            $totalWeight = (float) $items->sum('weight_kg');
            $packedWeight = (float) $items->whereNotNull('packed_at')->sum('weight_kg');
            $volumeUsed = (float) $items->sum(function (Item $item) {
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
                'notes' => $bag->notes,
                'checklist' => ChecklistSerializer::normalize($bag->checklist ?? []),
                'history' => [],
            ];
        });

        return new EloquentCollection($summary->values()->all());
    }

    protected function applyReservedCapacity(EloquentCollection &$bags, float $reservedKg, float $reservedVolumeCm3): void
    {
        $bags = new EloquentCollection(
            $bags->map(function (array $bag) use (&$reservedKg, &$reservedVolumeCm3) {
            $capacityKg = $bag['capacity_kg'] ?? 0;
            $totalKg = $bag['total_kg'] ?? 0;
            $availableKg = max($capacityKg - $totalKg, 0);
            $reservedKgApplied = min($availableKg, max($reservedKg, 0));
            $reservedKg -= $reservedKgApplied;

            $effectiveKg = $totalKg + $reservedKgApplied;
            $remainingKg = max($capacityKg - $effectiveKg, 0);

            $capacityVolumeCm3 = $bag['capacity_volume_cm3'] ?? null;
            $volumeUsedCm3 = $bag['total_volume_cm3'] ?? 0;
            $reservedVolumeApplied = 0.0;
            if ($capacityVolumeCm3 !== null) {
                $availableVolume = max($capacityVolumeCm3 - $volumeUsedCm3, 0);
                $reservedVolumeApplied = min($availableVolume, max($reservedVolumeCm3, 0));
                $reservedVolumeCm3 -= $reservedVolumeApplied;
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
            })->values()->all()
        );
    }

    protected function attachRecentHistory(EloquentCollection $bags, Move $move): void
    {
        $bagIds = $bags->pluck('id')->filter()->all();
        if (empty($bagIds)) {
            return;
        }

        $logs = BagActivityLog::query()
            ->where('move_id', $move->id)
            ->whereIn('bag_id', $bagIds)
            ->latest()
            ->limit(50)
            ->get()
            ->groupBy(fn (BagActivityLog $log) => (string) $log->bag_id);

        $bags->transform(function (array $bag) use ($logs) {
            $history = $logs[(string) $bag['id']] ?? collect();
            $bag['history'] = $history
                ->take(5)
                ->map(function (BagActivityLog $log) {
                    return [
                        'id' => $log->id,
                        'action' => $log->action,
                        'meta' => $log->meta ?? [],
                        'created_at' => optional($log->created_at)->toISOString(),
                    ];
                })
                ->values()
                ->all();

            return $bag;
        });
    }
}
