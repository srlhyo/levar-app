<?php

namespace Database\Factories;

use App\Models\MagicLink;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends Factory<MagicLink>
 */
class MagicLinkFactory extends Factory
{
    protected $model = MagicLink::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'token' => Str::uuid()->toString(),
            'expires_at' => now()->addMinutes(15),
            'used_at' => null,
        ];
    }
}
