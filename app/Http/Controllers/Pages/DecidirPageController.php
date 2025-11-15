<?php

namespace App\Http\Controllers\Pages;

use Inertia\Inertia;
use Inertia\Response;

class DecidirPageController
{
    public function __invoke(): Response
    {
        return Inertia::render('Decidir/Index');
    }
}
