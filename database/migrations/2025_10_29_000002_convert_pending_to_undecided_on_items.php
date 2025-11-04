<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('items')
            ->whereNull('decision')
            ->update(['decision' => 'undecided']);

        DB::table('items')
            ->where('decision', 'pending')
            ->update(['decision' => 'undecided']);
    }

    public function down(): void
    {
        DB::table('items')
            ->where('decision', 'undecided')
            ->update(['decision' => 'pending']);
    }
};
