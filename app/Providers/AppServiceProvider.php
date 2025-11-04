<?php

namespace App\Providers;

use App\Models\Move;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\ServiceProvider;
use Inertia\Inertia;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Inertia::share('auth', function () {
            $user = Auth::user();

            if (!$user) {
                return [
                    'user' => null,
                    'onboarding' => [
                        'history' => false,
                        'tour' => false,
                    ],
                ];
            }

            return [
                'user' => $user->only(['id', 'name', 'email']),
                'onboarding' => [
                    'history' => (bool) $user->onboarding_history_seen,
                    'tour' => (bool) $user->onboarding_tour_seen,
                ],
            ];
        });

        Inertia::share('move', function () {
            if (!Schema::hasTable('moves')) {
                return null;
            }

            $user = Auth::user();

            if (!$user) {
                return null;
            }

            $query = Move::query()->orderBy('id');

            $move = (clone $query)->where('user_id', $user->id)->first();

            if (!$move) {
                return null;
            }

            return [
                'id' => (string) $move->id,
                'origin' => $move->origin_country,
                'destination' => $move->destination_country,
                'reserved_kg' => (float) $move->reserved_weight_kg,
                'reserved_volume_cm3' => (float) $move->reserved_volume_cm3,
                'reserved_volume_liters' => $move->reserved_volume_cm3
                    ? round((float) $move->reserved_volume_cm3 / 1000, 2)
                    : 0.0,
            ];
        });

        Inertia::share('csrf_token', fn () => csrf_token());

        Inertia::share('pwa', function () {
            return [
                'vapidPublicKey' => config('services.webpush.public_key'),
            ];
        });
    }
}
