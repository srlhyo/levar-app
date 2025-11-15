<?php

namespace Database\Factories;

use App\Models\Bag;
use App\Models\Move;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends Factory<Bag>
 */
class BagFactory extends Factory
{
    protected $model = Bag::class;

    public function definition(): array
    {
        $code = strtoupper(Str::random(1));

        return [
            'move_id' => Move::factory(),
            'name' => 'Mala ' . $code,
            'code' => $code,
            'capacity_kg' => $this->faker->randomFloat(2, 18, 32),
            'notes' => null,
            'checklist' => [],
            'sort_order' => 0,
        ];
    }
}
