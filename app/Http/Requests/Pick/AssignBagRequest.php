<?php

namespace App\Http\Requests\Pick;

use Illuminate\Foundation\Http\FormRequest;

class AssignBagRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'bag' => ['nullable', 'string', 'max:50'],
        ];
    }
}
