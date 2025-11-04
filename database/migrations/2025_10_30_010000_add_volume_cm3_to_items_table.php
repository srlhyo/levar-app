<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('items', function (Blueprint $table) {
            $table->decimal('volume_cm3', 12, 2)->nullable()->after('weight_kg');
        });

        DB::table('items')
            ->select(['id', 'dimensions'])
            ->whereNotNull('dimensions')
            ->orderBy('id')
            ->chunkById(500, function ($items) {
                foreach ($items as $item) {
                    $parsed = \App\Support\DimensionParser::parse($item->dimensions);
                    if (!$parsed) {
                        continue;
                    }

                    DB::table('items')
                        ->where('id', $item->id)
                        ->update(['volume_cm3' => round($parsed['volume_cm3'], 2)]);
                }
            });
    }

    public function down(): void
    {
        Schema::table('items', function (Blueprint $table) {
            $table->dropColumn('volume_cm3');
        });
    }
};
