<?php

namespace Database\Factories;

use App\Models\DecisionLog;
use App\Models\Item;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<DecisionLog>
 */
class DecisionLogFactory extends Factory
{
    protected $model = DecisionLog::class;

    public function definition(): array
    {
        $from = $this->faker->randomElement([null, 'undecided', 'pending', 'yes', 'no']);
        $to = $this->faker->randomElement(array_filter(['undecided', 'pending', 'yes', 'no'], fn ($value) => $value !== $from));

        return [
            'item_id' => Item::factory(),
            'from_decision' => $from,
            'to_decision' => $to,
            'context' => ['source' => $this->faker->randomElement(['deck', 'bulk', 'requeue'])],
            'decided_by' => null,
            'created_at' => now(),
        ];
    }
}
