<?php

use App\Mail\MagicLinkMail;
use App\Models\MagicLink;
use App\Models\Move;
use App\Models\User;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Mail;

use function Pest\Laravel\actingAs;
use function Pest\Laravel\get;
use function Pest\Laravel\post;

beforeEach(function () {
    Mail::fake();
});

it('creates a user and magic link when requesting login', function () {
    post('/login', ['email' => 'test@example.com'])
        ->assertRedirect();

    $user = User::where('email', 'test@example.com')->first();
    expect($user)->not->toBeNull();

    $link = MagicLink::where('user_id', $user->id)->first();
    expect($link)->not->toBeNull();

    Mail::assertSent(MagicLinkMail::class, function (MagicLinkMail $mail) use ($user, $link) {
        return $mail->hasTo($user->email) && str_contains($mail->url, $link->token);
    });
});

it('consumes a magic link and authenticates the user', function () {
    $user = User::factory()->create(['email' => 'auth@example.com']);
    $move = Move::factory()->for($user)->create();

    $link = MagicLink::factory()->for($user)->create();

    get(route('auth.magic.consume', $link->token))
        ->assertRedirect(route('home'));

    expect(auth()->check())->toBeTrue();
    expect(auth()->id())->toBe($user->id);
    expect($link->fresh()->used_at)->not->toBeNull();
});

it('returns 410 when magic link is expired', function () {
    $user = User::factory()->create();
    $link = MagicLink::factory()->for($user)->create([
        'expires_at' => Carbon::now()->subMinute(),
    ]);

    get(route('auth.magic.consume', $link->token))->assertStatus(410);
});

it('returns 410 when magic link was already used', function () {
    $user = User::factory()->create();
    $link = MagicLink::factory()->for($user)->create([
        'used_at' => Carbon::now()->subMinute(),
    ]);

    get(route('auth.magic.consume', $link->token))->assertStatus(410);
});

it('allows authenticated users to access protected pages', function () {
    $user = User::factory()->create();
    Move::factory()->for($user)->create();

    actingAs($user);

    get(route('decidir.index'))->assertStatus(200);
});
