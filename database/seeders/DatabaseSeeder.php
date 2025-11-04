<?php

namespace Database\Seeders;

use App\Models\Move;
use App\Models\User;
use App\Services\MoveOnboardingService;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $user = User::factory()->create([
            'name' => 'Demo User',
            'email' => 'demo@example.com',
        ]);

        /** @var Move $move */
        $move = Move::factory()->for($user)->create([
            'origin_country' => 'GB',
            'destination_country' => 'BR',
            'reserved_weight_kg' => 4,
            'reserved_volume_cm3' => 60000,
        ]);

        app(MoveOnboardingService::class)->bootstrapDemoData($move, 60);
    }
}
