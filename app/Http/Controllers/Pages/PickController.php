<?php

namespace App\Http\Controllers\Pages;

use Inertia\Inertia;
use Inertia\Response;

class PickController
{
    public function __invoke(): Response
    {
        return Inertia::render('Pick/Index');
    }
}
