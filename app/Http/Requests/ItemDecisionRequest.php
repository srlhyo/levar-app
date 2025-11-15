<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ItemDecisionRequest extends FormRequest
{
    public function authorize(): bool
    {
        // Authorization is handled explicitly in the controller via InteractsWithMoves.
        return true;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'decision' => ['required', Rule::in(['undecided', 'pending', 'yes', 'no'])],
            'bag' => ['nullable', 'string', 'max:10'],
        ];
    }
}
