<?php

namespace Database\Factories;

use App\Models\Item;
use App\Models\ItemMedia;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends Factory<ItemMedia>
 */
class ItemMediaFactory extends Factory
{
    protected $model = ItemMedia::class;

    public function definition(): array
    {
        $filename = Str::uuid() . '.jpg';

        return [
            'item_id' => Item::factory(),
            'disk' => config('filesystems.default', 'public'),
            'path' => 'items/' . $filename,
            'thumb_path' => 'items/thumbs/' . $filename,
            'status' => 'done',
            'bytes' => $this->faker->numberBetween(50_000, 3_000_000),
            'width' => 1600,
            'height' => 1200,
            'mime' => 'image/jpeg',
            'uploaded_by' => null,
        ];
    }
}
