<?php

namespace App\Http\Requests\MoveConfig;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateMoveConfigRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        $bags = $this->input('bags');
        if (is_array($bags)) {
            $normalized = collect($bags)
                ->map(function ($bag) {
                    $bag = is_array($bag) ? $bag : [];
                    return [
                        'id' => $bag['id'] ?? null,
                        'name' => $bag['name'] ?? null,
                        'code' => $bag['code'] ?? null,
                        'capacity_kg' => $bag['capacity_kg'] ?? $bag['capacity'] ?? null,
                        'dimensions' => $bag['dimensions'] ?? null,
                        'sort_order' => $bag['sort_order'] ?? null,
                    ];
                })
                ->values()
                ->all();

            $this->merge(['bags' => $normalized]);
        }
    }

    public function rules(): array
    {
        return [
            'reserved_kg' => ['required', 'numeric', 'min:0', 'max:999'],
            'reserved_volume_liters' => ['nullable', 'numeric', 'min:0', 'max:9999'],
            'bags' => ['required', 'array', 'min:1'],
            'bags.*.id' => ['nullable', 'integer'],
            'bags.*.name' => ['required', 'string', 'max:120'],
            'bags.*.code' => ['nullable', 'string', 'max:10'],
            'bags.*.capacity_kg' => ['required', 'numeric', 'min:0'],
            'bags.*.dimensions' => ['nullable', 'string', 'max:120'],
        ];
    }

    public function messages(): array
    {
        return [
            'bags.required' => 'Cadastre ao menos uma mala.',
            'bags.*.name.required' => 'Toda mala precisa de um nome.',
            'bags.*.capacity_kg.required' => 'Informe a capacidade em kg da mala.',
        ];
    }
}
