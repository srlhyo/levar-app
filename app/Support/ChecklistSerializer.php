<?php

namespace App\Support;

use Illuminate\Support\Str;

class ChecklistSerializer
{
    /**
     * Normalize a checklist payload into consistent associative arrays.
     *
     * @param  mixed  $input
     * @return array<int, array{id:string,text:string,completed:bool}>
     */
    public static function normalize($input): array
    {
        if (!is_array($input)) {
            return [];
        }

        $normalized = [];

        foreach ($input as $entry) {
            if (!is_array($entry)) {
                continue;
            }

            $text = trim((string) ($entry['text'] ?? ''));
            if ($text === '') {
                continue;
            }

            $normalized[] = [
                'id' => (string) ($entry['id'] ?? Str::uuid()->toString()),
                'text' => Str::limit($text, 160, ''),
                'completed' => (bool) ($entry['completed'] ?? $entry['done'] ?? false),
            ];
        }

        return $normalized;
    }
}
