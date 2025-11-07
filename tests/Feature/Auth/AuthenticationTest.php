<?php

use App\Models\User;
use Illuminate\Support\Facades\Hash;

test('users can register', function () {
    $response = $this->post('/register', [
        'name' => 'Maria Demo',
        'email' => 'maria@example.com',
        'password' => 'password123',
        'password_confirmation' => 'password123',
    ]);

    $response->assertRedirect(route('home'));

    $this->assertDatabaseHas('users', [
        'email' => 'maria@example.com',
        'role' => User::ROLE_USER,
    ]);
});

test('users can login with valid credentials', function () {
    $user = User::factory()->create([
        'email' => 'joao@example.com',
        'password' => Hash::make('password123'),
    ]);

    $response = $this->post('/login', [
        'email' => 'joao@example.com',
        'password' => 'password123',
    ]);

    $response->assertRedirect(route('home'));
    $this->assertAuthenticatedAs($user);
});

test('non admins cannot access admin routes', function () {
    $user = User::factory()->create([
        'role' => User::ROLE_USER,
    ]);

    $response = $this->actingAs($user)->get('/share-inbox');

    $response->assertForbidden();
});
