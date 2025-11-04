<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class OnboardingController extends Controller
{
    public function update(Request $request): JsonResponse
    {
        $user = $request->user();

        $data = $request->validate([
            'history' => ['nullable', 'boolean'],
            'tour' => ['nullable', 'boolean'],
        ]);

        if (array_key_exists('history', $data)) {
            $user->onboarding_history_seen = (bool) $data['history'];
        }

        if (array_key_exists('tour', $data)) {
            $user->onboarding_tour_seen = (bool) $data['tour'];
        }

        $user->save();

        return response()->json([
            'history' => $user->onboarding_history_seen,
            'tour' => $user->onboarding_tour_seen,
        ]);
    }
}
