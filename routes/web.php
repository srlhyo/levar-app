<?php

use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', fn () => Inertia::render('Home'));
Route::get('/catalogar', fn () => Inertia::render('Catalogar/Index'));
Route::get('/decidir', fn () => Inertia::render('Decidir/Index'));
Route::get('/pick', fn () => Inertia::render('Pick/Index'));
Route::get('/resumo', fn () => Inertia::render('Resumo/Index'));
Route::get('/reciclagem', fn () => Inertia::render('Reciclagem/Index'));
Route::post('/share-inbox', fn () => Inertia::render('Share/Inbox'));
