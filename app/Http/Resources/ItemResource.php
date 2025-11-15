<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Http\Resources\MissingValue;

class ItemResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $bag = $this->resolveBag();

        return [
            'id' => (string) $this->id,
            'title' => $this->title,
            'name' => $this->title,
            'notes' => $this->notes,
            'weight' => $this->floatOrNull($this->weight_kg),
            'dimensions' => $this->dimensions,
            'volume_cm3' => $this->floatOrNull($this->volume_cm3),
            'volume_liters' => $this->calculateVolumeLiters(),
            'section' => $this->section,
            'category' => $this->category,
            'fragile' => (bool) $this->fragile,
            'decision' => $this->decision,
            'priority' => $this->priority,
            'bag' => $bag?->code,
            'bag_name' => $bag?->name,
            'bag_id' => $this->bag_id,
            'packed' => !is_null($this->packed_at),
            'packed_at' => optional($this->packed_at)->toISOString(),
            'sort_order' => $this->sort_order,
            'location' => $this->location_hint,
            'photo' => $this->thumbnail_url,
            'photo_url' => $this->photo_url,
            'thumbnail_url' => $this->thumbnail_url,
            'deleted' => $this->trashed(),
            'created_at' => optional($this->created_at)->toISOString(),
            'updated_at' => optional($this->updated_at)->toISOString(),
        ];
    }

    /**
     * @param  mixed  $value
     */
    private function floatOrNull($value): ?float
    {
        return $value !== null ? (float) $value : null;
    }

    private function calculateVolumeLiters(): ?float
    {
        if ($this->volume_cm3 === null) {
            return null;
        }

        return round((float) $this->volume_cm3 / 1000, 2);
    }

    private function resolveBag(): ?object
    {
        $bag = $this->whenLoaded('bag');

        if ($bag instanceof MissingValue) {
            return null;
        }

        return $bag;
    }
}
