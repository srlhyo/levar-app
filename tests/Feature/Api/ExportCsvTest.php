<?php

use App\Models\Item;
use App\Models\Move;
use App\Models\User;
use Laravel\Sanctum\Sanctum;

use function Pest\Laravel\post;

it('streams a csv containing only items marked to take', function () {
    $user = User::factory()->create();
    $move = Move::factory()->for($user)->create();

    $take = Item::factory()->forMove($move)->create([
        'decision' => 'yes',
        'title' => 'Guitarra elétrica',
        'weight_kg' => 3.4,
    ]);

    Item::factory()->forMove($move)->create([
        'decision' => 'no',
        'title' => 'Abajur vintage',
        'weight_kg' => 1.1,
    ]);

    Sanctum::actingAs($user);

    $response = post(route('api.export.csv', $move));

    $response->assertOk();
    $response->assertHeader('content-type', 'text/csv; charset=UTF-8');

    $csv = $response->streamedContent();

    expect($csv)->toContain($take->title);
    expect($csv)->not->toContain('Abajur vintage');
});
