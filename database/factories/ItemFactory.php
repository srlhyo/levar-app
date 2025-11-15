<?php

namespace Database\Factories;

use App\Models\Bag;
use App\Models\Item;
use App\Models\Move;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Item>
 */
class ItemFactory extends Factory
{
    protected $model = Item::class;

    public function definition(): array
    {
        $decision = $this->faker->randomElement(['undecided', 'pending', 'yes', 'no']);
        $packed = $decision === 'yes' && $this->faker->boolean(60);
        $priority = $this->faker->optional(0.5)->randomElement(['essential', 'priority', 'optional']);

        $length = $this->faker->numberBetween(15, 90);
        $width = $this->faker->numberBetween(10, 60);
        $height = $this->faker->numberBetween(5, 50);

        $dimensions = sprintf('%d × %d × %d cm', $length, $width, $height);
        $volume = $length * $width * $height;

        return [
            'move_id' => Move::factory(),
            'bag_id' => null,
            'title' => $this->faker->sentence(3),
            'notes' => $this->faker->optional(0.6)->sentence(10),
            'weight_kg' => $this->faker->randomFloat(2, 0.1, 3.5),
            'dimensions' => $dimensions,
            'volume_cm3' => $volume,
            'section' => $this->faker->randomElement(['living_room','kitchen','bedroom','office','bathroom','storage','other']),
            'category' => $this->faker->optional(0.4)->word(),
            'fragile' => $this->faker->boolean(25),
            'decision' => $decision,
            'priority' => $priority,
            'packed_at' => $packed ? $this->faker->dateTimeBetween('-10 days', 'now') : null,
            'sort_order' => $this->faker->numberBetween(0, 1000),
            'location_hint' => $this->faker->optional(0.3)->sentence(3),
            'photo_url' => null,
            'thumbnail_url' => null,
        ];
    }

    public function forMove(Move $move): static
    {
        return $this->state(fn () => [
            'move_id' => $move->id,
        ]);
    }

    public function forBag(Bag $bag): static
    {
        return $this->state(fn () => [
            'move_id' => $bag->move_id,
            'bag_id' => $bag->id,
        ]);
    }

    public function decision(string $decision): static
    {
        return $this->state(fn () => ['decision' => $decision]);
    }

    public function packed(): static
    {
        return $this->state(fn () => [
            'decision' => 'yes',
            'packed_at' => now(),
        ]);
    }
}
