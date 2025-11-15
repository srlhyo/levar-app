<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Concerns\InteractsWithMoves;
use App\Http\Controllers\Controller;
use App\Http\Requests\Pick\UpdateBagNotesRequest;
use App\Models\Bag;
use App\Services\BagActivityService;
use App\Support\ChecklistSerializer;
use Illuminate\Http\JsonResponse;

class BagNotesController extends Controller
{
    use InteractsWithMoves;

    public function __construct(
        private readonly BagActivityService $activityService,
    ) {
    }

    public function update(UpdateBagNotesRequest $request, Bag $bag): JsonResponse
    {
        $this->authorizeBag($request, $bag);

        $notes = $request->validated('notes');
        $checklist = ChecklistSerializer::normalize($request->validated('checklist') ?? []);

        $bag->update([
            'notes' => $notes,
            'checklist' => $checklist,
        ]);
        $this->activityService->logNotesUpdate($bag->fresh(), $request->user());

        return response()->json([
            'bag' => [
                'id' => (string) $bag->id,
                'notes' => $bag->notes,
                'checklist' => $bag->checklist ?? [],
            ],
        ]);
    }
}
