<?php

namespace App\Http\Controllers\Pages;

use Inertia\Inertia;
use Inertia\Response;

class ReciclagemController
{
    public function __invoke(): Response
    {
        return Inertia::render('Reciclagem/Index');
    }
}
