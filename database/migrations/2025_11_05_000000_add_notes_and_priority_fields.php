<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('bags', function (Blueprint $table) {
            $table->text('notes')->nullable()->after('dimensions');
            $table->json('checklist')->nullable()->after('notes');
        });

        Schema::table('items', function (Blueprint $table) {
            $table->string('priority', 20)->nullable()->after('decision');
        });
    }

    public function down(): void
    {
        Schema::table('items', function (Blueprint $table) {
            $table->dropColumn('priority');
        });

        Schema::table('bags', function (Blueprint $table) {
            $table->dropColumn(['notes', 'checklist']);
        });
    }
};
