<?php

return [
    'enabled' => (bool) env('NTFY_ENABLED', false),
    'base_url' => rtrim(env('NTFY_BASE_URL', 'https://ntfy.sh'), '/'),
    'topic' => env('NTFY_TOPIC'),
    'token' => env('NTFY_TOKEN'),
    'timeout' => (int) env('NTFY_TIMEOUT', 5),
];
