<?php

namespace App\Support;

class DimensionParser
{
    public static function parse(?string $raw): ?array
    {
        if (!is_string($raw) || trim($raw) === '') {
            return null;
        }

        $parts = preg_split('/[x×]/iu', $raw);
        if (!is_array($parts) || count($parts) < 3) {
            return null;
        }

        $values = [];

        foreach ($parts as $part) {
            if (count($values) >= 3) {
                break;
            }

            $normalized = preg_replace('/[^0-9,\.]/', '', (string) $part);
            if ($normalized === '') {
                continue;
            }

            $normalized = str_replace(',', '.', $normalized);
            $value = (float) $normalized;

            if ($value <= 0) {
                return null;
            }

            $values[] = $value;
        }

        if (count($values) < 3) {
            return null;
        }

        [$length, $width, $height] = array_slice($values, 0, 3);

        return [
            'length_cm' => $length,
            'width_cm' => $width,
            'height_cm' => $height,
            'volume_cm3' => $length * $width * $height,
        ];
    }
}
