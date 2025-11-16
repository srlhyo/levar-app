<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use Inertia\Inertia;
use Inertia\Response;

class RegisteredUserController extends Controller
{
    public function create(): Response
    {
        return Inertia::render('Auth/Register');
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255', 'unique:users,email'],
            'password' => ['required', 'confirmed', Password::defaults()],
            'is_admin' => ['nullable', 'boolean'],
        ]);

        $user = User::create([
            'name' => $data['name'],
            'email' => strtolower($data['email']),
            'password' => Hash::make($data['password']),
            'role' => $request->boolean('is_admin')
                ? User::ROLE_ADMIN
                : User::ROLE_USER,
        ]);

        Auth::login($user);
        $request->session()->regenerate();

        $user->moves()->firstOrCreate(
            ['user_id' => $user->id],
            [
                'origin_country' => 'GB',
                'destination_country' => 'BR',
                'reserved_weight_kg' => 4,
                'reserved_volume_cm3' => 60000,
            ],
        );

        return redirect()->route('home')->with('show_onboarding', true);
    }
}
