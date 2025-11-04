<?php

namespace Database\Factories;

use App\Models\Move;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Move>
 */
class MoveFactory extends Factory
{
    protected $model = Move::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'origin_country' => $this->faker->countryCode(),
            'destination_country' => $this->faker->countryCode(),
            'reserved_weight_kg' => 4,
            'reserved_volume_cm3' => 60000,
            'settings' => [
                'deck_hints' => $this->faker->boolean(70),
            ],
        ];
    }
}
