<?php

namespace App\Http\Controllers\Pages;

use Inertia\Inertia;
use Inertia\Response;

class ResumoController
{
    public function __invoke(): Response
    {
        return Inertia::render('Resumo/Index');
    }
}
