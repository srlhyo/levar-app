<?php

use App\Http\Controllers\Api\DecidirController;
use App\Http\Controllers\Api\ExportController;
use App\Http\Controllers\Api\ItemCatalogController;
use App\Http\Controllers\Api\ItemDecisionController;
use App\Http\Controllers\Api\ItemMediaController;
use App\Http\Controllers\Api\ItemPackController;
use App\Http\Controllers\Api\ItemRequeueController;
use App\Http\Controllers\Api\MoveConfigController;
use App\Http\Controllers\Api\PackController;
use App\Http\Controllers\Api\RecycleController;
use App\Http\Controllers\Api\ResumoController;
use App\Http\Controllers\Api\OnboardingController;
use App\Http\Controllers\Api\PushSubscriptionController;
use App\Http\Controllers\Api\UploadInboxController;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/moves/{move}/decidir', DecidirController::class)->name('api.decidir.index');
    Route::post('/items/{item}/decidir', [ItemDecisionController::class, 'store'])->name('api.items.decide');
    Route::post('/items/requeue', ItemRequeueController::class)->name('api.items.requeue');

    Route::post('/items/pack', ItemPackController::class)->name('api.items.pack');
    Route::get('/moves/{move}/pack', [PackController::class, 'index'])->name('api.pack.index');
    Route::post('/items/{item}/bag', [PackController::class, 'assign'])->name('api.pack.assign');

    Route::get('/moves/{move}/resumo', [ResumoController::class, 'index'])->name('api.resumo.index');
    Route::post('/moves/{move}/resumo/pending-to-leave', [ResumoController::class, 'movePendingToLeave'])->name('api.resumo.pending_to_leave');
    Route::get('/moves/{move}/config', [MoveConfigController::class, 'show'])->name('api.moves.config.show');
    Route::put('/moves/{move}/config', [MoveConfigController::class, 'update'])->name('api.moves.config.update');

    Route::get('/moves/{move}/recycle', [RecycleController::class, 'index'])->name('api.recycle.index');
    Route::post('/items/recycle', [RecycleController::class, 'softDelete'])->name('api.recycle.soft_delete');
    Route::post('/items/restore', [RecycleController::class, 'restore'])->name('api.recycle.restore');
    Route::delete('/items/{item}', [RecycleController::class, 'destroy'])->name('api.recycle.destroy');

    Route::post('/items/{item}/media', [ItemMediaController::class, 'store'])->name('api.media.store');
    Route::delete('/media/{media}', [ItemMediaController::class, 'destroy'])->name('api.media.destroy');

    Route::post('/moves/{move}/export/csv', ExportController::class)->name('api.export.csv');

    Route::get('/moves/{move}/uploads/inbox', UploadInboxController::class)->name('api.uploads.inbox');
    Route::get('/moves/{move}/items', [ItemCatalogController::class, 'index'])->name('api.items.index');
    Route::post('/moves/{move}/items', [ItemCatalogController::class, 'store'])->name('api.items.store');

    Route::post('/onboarding', [OnboardingController::class, 'update'])->name('api.onboarding.update');
    Route::post('/push-subscriptions', [PushSubscriptionController::class, 'store'])->name('api.push.store');
    Route::delete('/push-subscriptions', [PushSubscriptionController::class, 'destroy'])->name('api.push.destroy');
});
