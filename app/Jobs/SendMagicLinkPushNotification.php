<?php

namespace App\Jobs;

use App\Models\MagicLink;
use App\Notifications\MagicLinkNotification;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\URL;
use NotificationChannels\WebPush\WebPushChannel;

class SendMagicLinkPushNotification implements ShouldQueue
{
    use Dispatchable;
    use InteractsWithQueue;
    use Queueable;
    use SerializesModels;

    public function __construct(public MagicLink $link)
    {
    }

    public function handle(): void
    {
        $user = $this->link->user;
        if (!$user) {
            return;
        }

        $subscriptions = $this->resolvePushSubscriptions($user);

        if (
            $subscriptions->isNotEmpty()
            && class_exists(MagicLinkNotification::class)
            && class_exists(WebPushChannel::class)
        ) {
            $user->notify(new MagicLinkNotification($this->link));
            return;
        }

        $payload = [
            'title' => 'Seu link mágico chegou ✨',
            'body' => 'Toque para acessar o Levar e continuar a mudança.',
            'url' => URL::route('auth.magic.consume', ['token' => $this->link->token]),
            'icon' => '/icons/icon-192.png',
        ];

        foreach ($subscriptions as $subscription) {
            Log::info('Push notification pending delivery', [
                'endpoint' => $subscription->endpoint,
                'payload' => $payload,
            ]);
        }
    }

    /**
     * @return \Illuminate\Support\Collection<int, object>
     */
    protected function resolvePushSubscriptions(object $user): Collection
    {
        if (!class_exists(WebPushChannel::class)) {
            return collect();
        }

        if (!method_exists($user, 'routeNotificationFor')) {
            return collect();
        }

        $routes = $user->routeNotificationFor(WebPushChannel::class);

        if ($routes instanceof Collection) {
            return $routes;
        }

        if (is_array($routes)) {
            return collect($routes);
        }

        if ($routes) {
            return collect([$routes]);
        }

        return collect();
    }
}
