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
        $bag = $this->whenLoaded('bag');
        $bagModel = $bag instanceof MissingValue ? null : $bag;

        return [
            'id' => (string) $this->id,
            'title' => $this->title,
            'name' => $this->title,
            'notes' => $this->notes,
            'weight' => $this->weight_kg !== null ? (float) $this->weight_kg : null,
            'dimensions' => $this->dimensions,
            'volume_cm3' => $this->volume_cm3 !== null ? (float) $this->volume_cm3 : null,
            'volume_liters' => $this->volume_cm3 !== null ? round((float) $this->volume_cm3 / 1000, 2) : null,
            'section' => $this->section,
            'category' => $this->category,
            'fragile' => (bool) $this->fragile,
            'decision' => $this->decision,
            'bag' => $bagModel?->code,
            'bag_name' => $bagModel?->name,
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
}
