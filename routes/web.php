<?php

use App\Http\Controllers\Auth\MagicLinkController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::middleware('guest')->group(function () {
    Route::get('/login', [MagicLinkController::class, 'create'])->name('login');
    Route::post('/login', [MagicLinkController::class, 'store'])->name('login.store');
});

Route::get('/auth/magic/{token}', [MagicLinkController::class, 'consume'])->name('auth.magic.consume');

Route::middleware('auth')->group(function () {
    Route::get('/', fn () => Inertia::render('Home'))->name('home');
    Route::get('/catalogar', fn () => Inertia::render('Catalogar/Index'))->name('catalogar.index');
    Route::get('/decidir', fn () => Inertia::render('Decidir/Index'))->name('decidir.index');
    Route::get('/pick', fn () => Inertia::render('Pick/Index'))->name('pick.index');
    Route::get('/resumo', fn () => Inertia::render('Resumo/Index'))->name('resumo.index');
    Route::get('/reciclagem', fn () => Inertia::render('Reciclagem/Index'))->name('reciclagem.index');
    Route::get('/share-inbox', fn () => Inertia::render('Share/Inbox'))->name('share.inbox');
    Route::post('/share-inbox', fn () => Inertia::render('Share/Inbox'))->name('share.inbox.store');
    Route::get('/logout', [MagicLinkController::class, 'destroy'])->name('logout');
});
