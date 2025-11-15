<?php

namespace App\Http\Controllers\Pages;

use Inertia\Inertia;
use Inertia\Response;

class ShareInboxController
{
    public function __invoke(): Response
    {
        return Inertia::render('Share/Inbox');
    }
}
