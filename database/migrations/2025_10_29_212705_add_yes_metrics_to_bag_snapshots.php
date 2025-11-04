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
        Schema::table('bag_snapshots', function (Blueprint $table) {
            $table->decimal('yes_kg', 8, 2)->default(0)->after('decided_count');
            $table->json('yes_dimensions')->nullable()->after('yes_kg');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('bag_snapshots', function (Blueprint $table) {
            $table->dropColumn(['yes_kg', 'yes_dimensions']);
        });
    }
};
