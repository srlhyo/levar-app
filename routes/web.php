<?php

use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\Auth\RegisteredUserController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::middleware('guest')->group(function () {
    Route::get('/register', [RegisteredUserController::class, 'create'])->name('register');
    Route::post('/register', [RegisteredUserController::class, 'store']);

    Route::get('/login', [AuthenticatedSessionController::class, 'create'])->name('login');
    Route::post('/login', [AuthenticatedSessionController::class, 'store']);
});

Route::middleware('auth')->group(function () {
    Route::get('/', fn () => Inertia::render('Home'))->name('home');
    Route::get('/catalogar', fn () => Inertia::render('Catalogar/Index'))->name('catalogar.index');
    Route::get('/decidir', fn () => Inertia::render('Decidir/Index'))->name('decidir.index');
    Route::get('/pick', fn () => Inertia::render('Pick/Index'))->name('pick.index');
    Route::get('/resumo', fn () => Inertia::render('Resumo/Index'))->name('resumo.index');
    Route::get('/reciclagem', fn () => Inertia::render('Reciclagem/Index'))->name('reciclagem.index');

    Route::middleware('can:access-admin')->group(function () {
        Route::get('/share-inbox', fn () => Inertia::render('Share/Inbox'))->name('share.inbox');
        Route::post('/share-inbox', fn () => Inertia::render('Share/Inbox'))->name('share.inbox.store');
    });

    Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])->name('logout');

    Route::prefix('api')->group(function () {
        Route::get('/moves/{move}/decidir', \App\Http\Controllers\Api\DecidirController::class)->name('api.decidir.index');
        Route::post('/items/{item}/decidir', [\App\Http\Controllers\Api\ItemDecisionController::class, 'store'])->name('api.items.decide');
        Route::post('/items/requeue', \App\Http\Controllers\Api\ItemRequeueController::class)->name('api.items.requeue');

        Route::post('/items/pack', \App\Http\Controllers\Api\ItemPackController::class)->name('api.items.pack');
        Route::get('/moves/{move}/pack', [\App\Http\Controllers\Api\PackController::class, 'index'])->name('api.pack.index');
        Route::post('/items/{item}/bag', [\App\Http\Controllers\Api\PackController::class, 'assign'])->name('api.pack.assign');

        Route::get('/moves/{move}/resumo', [\App\Http\Controllers\Api\ResumoController::class, 'index'])->name('api.resumo.index');
        Route::post('/moves/{move}/resumo/pending-to-leave', [\App\Http\Controllers\Api\ResumoController::class, 'movePendingToLeave'])->name('api.resumo.pending_to_leave');
        Route::get('/moves/{move}/config', [\App\Http\Controllers\Api\MoveConfigController::class, 'show'])->name('api.moves.config.show');
        Route::put('/moves/{move}/config', [\App\Http\Controllers\Api\MoveConfigController::class, 'update'])->name('api.moves.config.update');

        Route::get('/moves/{move}/recycle', [\App\Http\Controllers\Api\RecycleController::class, 'index'])->name('api.recycle.index');
        Route::post('/items/recycle', [\App\Http\Controllers\Api\RecycleController::class, 'softDelete'])->name('api.recycle.soft_delete');
        Route::post('/items/restore', [\App\Http\Controllers\Api\RecycleController::class, 'restore'])->name('api.recycle.restore');
        Route::delete('/items/{item}', [\App\Http\Controllers\Api\RecycleController::class, 'destroy'])->name('api.recycle.destroy');

        Route::post('/items/{item}/media', [\App\Http\Controllers\Api\ItemMediaController::class, 'store'])->name('api.media.store');
        Route::delete('/media/{media}', [\App\Http\Controllers\Api\ItemMediaController::class, 'destroy'])->name('api.media.destroy');

        Route::post('/moves/{move}/export/csv', \App\Http\Controllers\Api\ExportController::class)->name('api.export.csv');

        Route::get('/moves/{move}/uploads/inbox', \App\Http\Controllers\Api\UploadInboxController::class)->name('api.uploads.inbox');
        Route::get('/moves/{move}/items', [\App\Http\Controllers\Api\ItemCatalogController::class, 'index'])->name('api.items.index');
        Route::post('/moves/{move}/items', [\App\Http\Controllers\Api\ItemCatalogController::class, 'store'])->name('api.items.store');
    });
});
