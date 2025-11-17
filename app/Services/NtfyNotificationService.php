<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;
use Throwable;

class NtfyNotificationService
{
    public function notifyLogin(User $user, Request $request): void
    {
        $this->sendEvent('Login detectado', 'login', $user, $request, ['tags' => ['white_check_mark']]);
    }

    public function notifyLogout(?User $user, Request $request): void
    {
        $this->sendEvent('Logout detectado', 'logout', $user, $request, ['tags' => ['door']]);
    }

    /**
     * @param  array{
     *     tags?: array<int, string>|string,
     *     click?: string|null,
     * }  $options
     */
    private function sendEvent(string $title, string $action, ?User $user, Request $request, array $options = []): void
    {
        if (!$this->isEnabled()) {
            return;
        }

        $topic = Config::get('ntfy.topic');

        if (!$topic) {
            return;
        }

        $lines = [
            sprintf('Ação: %s', Str::headline($action)),
            sprintf('Usuário: %s', $user?->email ?? 'N/D'),
            sprintf('IP: %s', $request->ip() ?? 'desconhecido'),
            sprintf('Agente: %s', $request->userAgent() ?? 'desconhecido'),
            sprintf('Quando: %s', now()->toDateTimeString()),
        ];

        $message = implode(PHP_EOL, $lines);

        $this->send($topic, $title, $message, $options);
    }

    /**
     * @param  array{
     *     tags?: array<int, string>|string,
     *     click?: string|null,
     * }  $options
     */
    public function send(string $topic, string $title, string $message, array $options = []): void
    {
        if (!$this->isEnabled()) {
            return;
        }

        $baseUrl = Config::get('ntfy.base_url', 'https://ntfy.sh');
        $url = rtrim($baseUrl, '/') . '/' . ltrim($topic, '/');

        $headers = [
            'X-Title' => $title,
        ];

        if (!empty($options['tags'])) {
            $tags = is_array($options['tags']) ? implode(',', $options['tags']) : $options['tags'];
            $headers['X-Tags'] = $tags;
        }

        if (!empty($options['click'])) {
            $headers['X-Click'] = $options['click'];
        }

        $request = Http::timeout(Config::get('ntfy.timeout', 5))
            ->withHeaders($headers);

        if ($token = Config::get('ntfy.token')) {
            $request = $request->withToken($token);
        }

        try {
            $request->withBody($message, 'text/plain')->post($url);
        } catch (Throwable $exception) {
            report($exception);
        }
    }

    private function isEnabled(): bool
    {
        return (bool) Config::get('ntfy.enabled', false);
    }
}
