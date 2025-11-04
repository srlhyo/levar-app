<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class MagicLinkMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(public string $url)
    {
    }

    public function build(): self
    {
        return $this
            ->subject('Seu link mágico para entrar no Levar')
            ->view('mail.magic-link')
            ->with([
                'url' => $this->url,
            ]);
    }
}

