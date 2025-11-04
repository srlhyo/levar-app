<?php

use App\Models\Bag;
use App\Models\Item;
use App\Models\Move;
use App\Models\User;
use Illuminate\Support\Str;
use Laravel\Sanctum\Sanctum;

use function Pest\Laravel\getJson;

it('returns aggregated stats and lists for resumo', function () {
    $user = User::factory()->create();
    $move = Move::factory()->for($user)->create([
        'reserved_weight_kg' => 5,
    ]);

    /** @var Bag $bag */
    $bag = $move->bags()->create([
        'name' => 'Mala D',
        'code' => 'D' . Str::upper(Str::random(1)),
        'capacity_kg' => 23,
        'dimensions' => '60 × 45 × 25 cm',
        'sort_order' => 0,
    ]);

    Item::factory()->forMove($move)->forBag($bag)->create([
        'decision' => 'yes',
        'weight_kg' => 2.5,
        'packed_at' => now(),
        'dimensions' => '50 × 40 × 30 cm',
        'volume_cm3' => 60000,
    ]);

    Item::factory()->forMove($move)->create([
        'decision' => 'undecided',
        'weight_kg' => 1.2,
        'dimensions' => '40 × 30 × 20 cm',
        'volume_cm3' => 24000,
    ]);

    Item::factory()->forMove($move)->create([
        'decision' => 'pending',
        'weight_kg' => 1.1,
        'dimensions' => '35 × 25 × 18 cm',
        'volume_cm3' => 15750,
    ]);

    Item::factory()->forMove($move)->create([
        'decision' => 'no',
        'weight_kg' => 0.8,
        'dimensions' => '30 × 20 × 15 cm',
        'volume_cm3' => 9000,
    ]);

    Sanctum::actingAs($user);

    $response = getJson(route('api.resumo.index', $move));

    $response->assertOk();

    $response->assertJsonPath('stats.total', 4);
    $response->assertJsonPath('stats.take', 1);
    $response->assertJsonPath('stats.pending_total', 1);
    $response->assertJsonPath('stats.pending', 1);
    $response->assertJsonPath('stats.leave', 1);
    $response->assertJsonPath('stats.undecided', 1);
    $response->assertJsonPath('bags.0.total_kg', 2.5);
    $response->assertJsonPath('bags.0.packed_kg', 2.5);
    $response->assertJsonPath('bags.0.total_volume_cm3', 60000);
    $response->assertJsonPath('stats.volumes.volume_cm3', 60000);
    $response->assertJsonPath('stats.volumes.capacity_cm3', 67500);
    $response->assertJsonPath('stats.volumes.reserved_cm3', (int) $move->reserved_volume_cm3);
    $response->assertJsonPath('stats.volumes.available_cm3', 7500);
    $response->assertJsonPath('stats.volumes.remaining_cm3', -52500);
    $response->assertJsonPath('lists.take.0.decision', 'yes');
    $response->assertJsonPath('lists.undecided.0.decision', 'undecided');
    $response->assertJsonPath('lists.pending.0.decision', 'pending');
});
