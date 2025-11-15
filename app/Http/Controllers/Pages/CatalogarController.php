<?php

namespace App\Http\Controllers\Pages;

use Inertia\Inertia;
use Inertia\Response;

class CatalogarController
{
    public function __invoke(): Response
    {
        return Inertia::render('Catalogar/Index');
    }
}
