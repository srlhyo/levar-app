<?php

use App\Models\Bag;
use App\Models\DecisionLog;
use App\Models\Item;
use App\Models\Move;
use App\Models\User;
use Illuminate\Support\Str;
use Laravel\Sanctum\Sanctum;

use function Pest\Laravel\postJson;

it('updates an item decision and logs the transition', function () {
    $user = User::factory()->create();
    $move = Move::factory()->for($user)->create();

    /** @var Bag $bag */
    $bag = $move->bags()->create([
        'name' => 'Mala Teste',
        'code' => 'T' . Str::upper(Str::random(1)),
        'capacity_kg' => 20,
        'sort_order' => 0,
    ]);

    /** @var Item $item */
    $item = Item::factory()->forMove($move)->create([
        'decision' => 'undecided',
        'weight_kg' => 1.2,
    ]);

    Sanctum::actingAs($user);

    $response = postJson(route('api.items.decide', $item), [
        'decision' => 'yes',
        'bag' => $bag->code,
    ]);

    $response
        ->assertOk()
        ->assertJsonPath('item.decision', 'yes')
        ->assertJsonPath('item.bag', $bag->code);

    expect(DecisionLog::where('item_id', $item->id)->count())->toBeGreaterThan(0);
    expect($item->fresh()->bag_id)->toBe($bag->id);
    expect($move->snapshot()->exists())->toBeTrue();
});
