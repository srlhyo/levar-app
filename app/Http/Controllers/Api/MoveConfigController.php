<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Requests\MoveConfig\UpdateMoveConfigRequest;
use App\Models\Bag;
use App\Models\Move;
use App\Services\MoveConfigService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MoveConfigController extends Controller
{
    use InteractsWithMoves;

    public function show(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $move->load(['bags' => fn ($query) => $query->orderBy('sort_order')]);

        return response()->json([
            'reserved_kg' => (float) $move->reserved_weight_kg,
            'reserved_volume_cm3' => (float) $move->reserved_volume_cm3,
            'reserved_volume_liters' => $move->reserved_volume_cm3 ? round($move->reserved_volume_cm3 / 1000, 2) : 0,
            'bags' => $move->bags->map(fn (Bag $bag) => [
                'id' => (int) $bag->id,
                'name' => $bag->name,
                'code' => $bag->code,
                'capacity_kg' => (float) $bag->capacity_kg,
                'dimensions' => $bag->dimensions,
                'sort_order' => (int) $bag->sort_order,
            ]),
        ]);
    }

    public function update(UpdateMoveConfigRequest $request, Move $move, MoveConfigService $service): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $service->update($move, $request->validated());

        return response()->json([
            'status' => 'ok',
        ]);
    }
}
