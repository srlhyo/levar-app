<?php

namespace App\Notifications;

use App\Models\MagicLink;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;

class MagicLinkNotification extends Notification
{
    use Queueable;

    public function __construct(public MagicLink $link)
    {
    }

    public function via(object $notifiable): array
    {
        $channels = [];

        if (class_exists(\NotificationChannels\WebPush\WebPushChannel::class)) {
            $channels[] = \NotificationChannels\WebPush\WebPushChannel::class;
        }

        return $channels;
    }

    public function toWebPush(object $notifiable)
    {
        if (!class_exists(\NotificationChannels\WebPush\WebPushMessage::class)) {
            return null;
        }

        return (new \NotificationChannels\WebPush\WebPushMessage())
            ->title('Seu link mágico chegou ✨')
            ->icon('/icons/icon-192.png')
            ->body('Toque para acessar o Levar e continuar a mudança.')
            ->data([
                'url' => route('auth.magic.consume', ['token' => $this->link->token]),
            ]);
    }
}
