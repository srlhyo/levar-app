<?php

use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', fn () => Inertia::render('Home'))->name('home');
Route::get('/catalogar', fn () => Inertia::render('Catalogar/Index'))->name('catalogar.index');
Route::get('/decidir', fn () => Inertia::render('Decidir/Index'))->name('decidir.index');
Route::get('/pick', fn () => Inertia::render('Pick/Index'))->name('pick.index');
Route::get('/resumo', fn () => Inertia::render('Resumo/Index'))->name('resumo.index');
Route::get('/reciclagem', fn () => Inertia::render('Reciclagem/Index'))->name('reciclagem.index');
Route::get('/share-inbox', fn () => Inertia::render('Share/Inbox'))->name('share.inbox');
Route::post('/share-inbox', fn () => Inertia::render('Share/Inbox'))->name('share.inbox.store');
