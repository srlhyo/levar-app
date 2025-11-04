<?php

use App\Models\Item;
use App\Models\Move;
use App\Models\User;
use Laravel\Sanctum\Sanctum;

use function Pest\Laravel\postJson;

it('requeues items to the top of the pending deck', function () {
    $user = User::factory()->create();
    $move = Move::factory()->for($user)->create();

    $anchor = Item::factory()->forMove($move)->create([
        'decision' => 'undecided',
        'sort_order' => 50,
    ]);

    $first = Item::factory()->forMove($move)->create([
        'decision' => 'undecided',
        'sort_order' => 120,
    ]);

    $second = Item::factory()->forMove($move)->create([
        'decision' => 'undecided',
        'sort_order' => 160,
    ]);

    Sanctum::actingAs($user);

    $response = postJson(route('api.items.requeue'), [
        'ids' => [$first->id, $second->id],
    ]);

    $response->assertOk();

    $freshAnchor = $anchor->fresh();
    $freshFirst = $first->fresh();
    $freshSecond = $second->fresh();

    expect($freshAnchor->sort_order)->toBe(50);
    expect($freshFirst->sort_order)->toBeLessThan($freshAnchor->sort_order);
    expect($freshSecond->sort_order)->toBeLessThan($freshFirst->sort_order);
});
