<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Models\Bag;
use App\Models\Move;
use App\Services\BagSnapshotService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

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

    public function update(Request $request, Move $move): JsonResponse
    {
        $this->authorizeMove($request, $move);

        $validated = $request->validate([
            'reserved_kg' => ['required', 'numeric', 'min:0', 'max:999'],
            'reserved_volume_liters' => ['nullable', 'numeric', 'min:0', 'max:9999'],
            'bags' => ['required', 'array', 'min:1'],
            'bags.*.id' => ['nullable', 'integer'],
            'bags.*.name' => ['required', 'string', 'max:120'],
            'bags.*.code' => ['nullable', 'string', 'max:10'],
            'bags.*.capacity_kg' => ['required', 'numeric', 'min:0'],
            'bags.*.dimensions' => ['nullable', 'string', 'max:120'],
        ]);

        DB::transaction(function () use ($move, $validated) {
            $move->update([
                'reserved_weight_kg' => $validated['reserved_kg'],
                'reserved_volume_cm3' => isset($validated['reserved_volume_liters'])
                    ? round($validated['reserved_volume_liters'] * 1000, 2)
                    : 0,
            ]);

            $incoming = collect($validated['bags']);
            $existing = $move->bags()->get()->keyBy('id');
            $processedIds = [];

            foreach ($incoming as $index => $bagData) {
                $payload = [
                    'name' => $bagData['name'],
                    'code' => $bagData['code'] ?? null,
                    'capacity_kg' => $bagData['capacity_kg'],
                    'dimensions' => $bagData['dimensions'] ?? null,
                    'sort_order' => $index,
                ];

                if (!empty($bagData['id']) && $existing->has((int) $bagData['id'])) {
                    /** @var Bag $bag */
                    $bag = $existing[(int) $bagData['id']];
                    $bag->update($payload);
                    $processedIds[] = $bag->id;
                } else {
                    $bag = $move->bags()->create($payload);
                    $processedIds[] = $bag->id;
                }
            }

            $move->bags()
                ->whereNotIn('id', $processedIds)
                ->get()
                ->each(function (Bag $bag) {
                    $bag->items()->update([
                        'bag_id' => null,
                    ]);

                    $bag->delete();
                });
        });

        app(BagSnapshotService::class)->refresh($move->fresh('bags'));

        return response()->json([
            'status' => 'ok',
        ]);
    }
}
