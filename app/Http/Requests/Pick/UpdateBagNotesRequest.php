<?php

namespace App\Http\Requests\Pick;

use Illuminate\Foundation\Http\FormRequest;

class UpdateBagNotesRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'notes' => ['nullable', 'string', 'max:1200'],
            'checklist' => ['nullable', 'array', 'max:25'],
            'checklist.*.id' => ['nullable', 'string', 'max:64'],
            'checklist.*.text' => ['required', 'string', 'max:160'],
            'checklist.*.completed' => ['nullable', 'boolean'],
        ];
    }
}
