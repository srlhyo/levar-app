<?php

namespace App\Http\Requests\Resumo;

use Illuminate\Foundation\Http\FormRequest;

class MovePendingToLeaveRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'ids' => ['required', 'array', 'min:1'],
            'ids.*' => ['integer', 'distinct'],
        ];
    }
}
