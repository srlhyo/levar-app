<?php

namespace App\Services;

use App\Models\Item;
use App\Models\Move;

class CatalogItemService
{
    public function create(Move $move, array $data): Item
    {
        return $move->items()->create([
            'title' => $data['title'],
            'notes' => $data['notes'] ?? null,
            'weight_kg' => (float) $data['weight_kg'],
            'volume_cm3' => (float) $data['volume_cm3'],
            'category' => $data['category'] ?? null,
            'fragile' => (bool) $data['fragile'],
            'decision' => 'undecided',
            'sort_order' => $this->nextSortOrder($move),
        ]);
    }

    protected function nextSortOrder(Move $move): int
    {
        $maxSort = (int) $move->items()->max('sort_order');

        return $maxSort + 10;
    }
}
