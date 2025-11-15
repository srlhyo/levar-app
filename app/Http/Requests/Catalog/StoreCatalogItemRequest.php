<?php

namespace App\Http\Requests\Catalog;

use Illuminate\Foundation\Http\FormRequest;

class StoreCatalogItemRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        $weight = $this->input('weight_kg', $this->input('weight'));
        $volume = $this->input('volume_cm3', $this->input('volume'));

        $this->merge([
            'weight_kg' => $this->parseNumeric($weight),
            'volume_cm3' => $this->parseNumeric($volume),
            'title' => $this->input('title', $this->input('name')),
        ]);
    }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:160'],
            'notes' => ['nullable', 'string'],
            'weight_kg' => ['required', 'numeric', 'min:0.01'],
            'volume_cm3' => ['required', 'numeric', 'min:1'],
            'category' => ['nullable', 'string', 'max:80'],
            'fragile' => ['required', 'boolean'],
        ];
    }

    private function parseNumeric($value): ?float
    {
        if ($value === null || $value === '') {
            return null;
        }

        if (is_string($value)) {
            $value = str_replace(['.', ','], ['', '.'], $value);
        }

        return is_numeric($value) ? (float) $value : null;
    }
}
