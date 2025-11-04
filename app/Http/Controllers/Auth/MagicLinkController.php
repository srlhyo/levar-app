<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Jobs\SendMagicLinkPushNotification;
use App\Mail\MagicLinkMail;
use App\Models\MagicLink;
use App\Models\User;
use App\Services\MoveOnboardingService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Inertia\Inertia;
use Inertia\Response;

class MagicLinkController extends Controller
{
    public function __construct(
        private readonly MoveOnboardingService $onboardingService,
    ) {
    }

    public function create(Request $request): Response
    {
        $request->session()->regenerateToken();

        return Inertia::render('Auth/MagicLink', [
            'status' => session('status'),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
        ]);

        $email = Str::lower($data['email']);

        $user = User::firstOrCreate(
            ['email' => $email],
            ['name' => Str::headline(Str::before($email, '@'))]
        );

        $token = Str::uuid()->toString();

        $magicLink = $user->magicLinks()->create([
            'token' => $token,
            'expires_at' => now()->addMinutes(15),
        ]);

        $url = route('auth.magic.consume', ['token' => $magicLink->token]);

        Mail::to($email)->send(new MagicLinkMail($url));

        SendMagicLinkPushNotification::dispatchSync($magicLink->fresh(['user']));

        if (app()->environment('local')) {
            logger()->info('Magic link generated', [
                'email' => $email,
                'url' => $url,
            ]);
        }

        return back()->with('status', 'Enviamos um link mágico para o seu email.');
    }

    public function consume(Request $request, string $token): RedirectResponse|JsonResponse
    {
        $link = MagicLink::query()
            ->where('token', $token)
            ->whereNull('used_at')
            ->where('expires_at', '>=', now())
            ->first();

        if (!$link) {
            $request->session()->regenerateToken();

            return redirect()
                ->route('login')
                ->with('status', 'O link expirou. Solicite um novo para continuar.');
        }

        $user = $link->user;

        $link->forceFill(['used_at' => now()])->save();

        Auth::login($user);
        $request->session()->regenerate();

        $move = $user->moves()->firstOrCreate(
            ['user_id' => $user->id],
            [
                'origin_country' => 'GB',
                'destination_country' => 'BR',
                'reserved_weight_kg' => 4,
                'reserved_volume_cm3' => 60000,
            ]
        );

        $this->onboardingService->bootstrapDemoData($move);

        return redirect()->route('home');
    }

    public function destroy(Request $request): RedirectResponse
    {
        Auth::logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->route('login');
    }
}
