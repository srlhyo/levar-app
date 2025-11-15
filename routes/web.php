<?php

use App\Http\Controllers\Api\BagNotesController;
use App\Http\Controllers\Api\DecidirController;
use App\Http\Controllers\Api\ExportController;
use App\Http\Controllers\Api\ItemCatalogController;
use App\Http\Controllers\Api\ItemDecisionController;
use App\Http\Controllers\Api\ItemMediaController;
use App\Http\Controllers\Api\ItemPackController;
use App\Http\Controllers\Api\ItemPriorityController;
use App\Http\Controllers\Api\BagSummaryController;
use App\Http\Controllers\Api\ItemRequeueController;
use App\Http\Controllers\Api\MoveConfigController;
use App\Http\Controllers\Api\PackController;
use App\Http\Controllers\Api\RecycleController;
use App\Http\Controllers\Api\ResumoController;
use App\Http\Controllers\Api\UploadInboxController;
use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\Auth\RegisteredUserController;
use App\Http\Controllers\Pages\CatalogarController;
use App\Http\Controllers\Pages\DecidirPageController;
use App\Http\Controllers\Pages\HomeController;
use App\Http\Controllers\Pages\PickController;
use App\Http\Controllers\Pages\ReciclagemController;
use App\Http\Controllers\Pages\ResumoController as ResumoPageController;
use App\Http\Controllers\Pages\ShareInboxController;
use Illuminate\Support\Facades\Route;

Route::middleware('guest')->group(function () {
    Route::get('/register', [RegisteredUserController::class, 'create'])->name('register');
    Route::post('/register', [RegisteredUserController::class, 'store']);

    Route::get('/login', [AuthenticatedSessionController::class, 'create'])->name('login');
    Route::post('/login', [AuthenticatedSessionController::class, 'store']);
});

Route::middleware('auth')->group(function () {
    Route::get('/', HomeController::class)->name('home');
    Route::get('/catalogar', CatalogarController::class)->name('catalogar.index');
    Route::get('/decidir', DecidirPageController::class)->name('decidir.index');
    Route::get('/pick', PickController::class)->name('pick.index');
    Route::get('/resumo', ResumoPageController::class)->name('resumo.index');
    Route::get('/reciclagem', ReciclagemController::class)->name('reciclagem.index');

    Route::middleware('can:access-admin')->group(function () {
        Route::get('/share-inbox', ShareInboxController::class)->name('share.inbox');
        Route::post('/share-inbox', ShareInboxController::class)->name('share.inbox.store');
    });

    Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])->name('logout');

    Route::prefix('api')
        ->name('api.')
        ->group(function () {
            Route::get('/moves/{move}/decidir', DecidirController::class)->name('decidir.index');
            Route::post('/items/{item}/decidir', [ItemDecisionController::class, 'store'])->name('items.decide');
            Route::post('/items/requeue', ItemRequeueController::class)->name('items.requeue');

            Route::post('/items/pack', ItemPackController::class)->name('items.pack');
            Route::get('/moves/{move}/pack', [PackController::class, 'index'])->name('pack.index');
            Route::post('/items/{item}/bag', [PackController::class, 'assign'])->name('pack.assign');
            Route::put('/items/{item}/priority', [ItemPriorityController::class, 'update'])->name('items.priority');

            Route::get('/moves/{move}/resumo', [ResumoController::class, 'index'])->name('resumo.index');
            Route::post('/moves/{move}/resumo/pending-to-leave', [ResumoController::class, 'movePendingToLeave'])->name('resumo.pending_to_leave');
            Route::get('/moves/{move}/config', [MoveConfigController::class, 'show'])->name('moves.config.show');
            Route::put('/moves/{move}/config', [MoveConfigController::class, 'update'])->name('moves.config.update');
            Route::put('/bags/{bag}/notes', [BagNotesController::class, 'update'])->name('bags.notes');
            Route::get('/bags/{bag}/summary', [BagSummaryController::class, 'show'])->name('bags.summary');

            Route::get('/moves/{move}/recycle', [RecycleController::class, 'index'])->name('recycle.index');
            Route::post('/items/recycle', [RecycleController::class, 'softDelete'])->name('recycle.soft_delete');
            Route::post('/items/restore', [RecycleController::class, 'restore'])->name('recycle.restore');
            Route::delete('/items/{item}', [RecycleController::class, 'destroy'])->name('recycle.destroy');

            Route::post('/items/{item}/media', [ItemMediaController::class, 'store'])->name('media.store');
            Route::delete('/media/{media}', [ItemMediaController::class, 'destroy'])->name('media.destroy');

            Route::post('/moves/{move}/export/csv', ExportController::class)->name('export.csv');

            Route::get('/moves/{move}/uploads/inbox', UploadInboxController::class)->name('uploads.inbox');
            Route::get('/moves/{move}/items', [ItemCatalogController::class, 'index'])->name('items.index');
            Route::post('/moves/{move}/items', [ItemCatalogController::class, 'store'])->name('items.store');
        });
});
