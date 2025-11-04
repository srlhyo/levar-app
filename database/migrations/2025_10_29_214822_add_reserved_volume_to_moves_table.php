<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('moves', function (Blueprint $table) {
            $table->decimal('reserved_volume_cm3', 12, 2)->default(0)->after('reserved_weight_kg');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('moves', function (Blueprint $table) {
            $table->dropColumn('reserved_volume_cm3');
        });
    }
};
