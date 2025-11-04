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
        Schema::create('bags', function (Blueprint $table) {
            $table->id();
            $table->foreignId('move_id')->constrained()->cascadeOnDelete();
            $table->string('name', 80);
            $table->string('code', 10);
            $table->decimal('capacity_kg', 5, 2)->default(23.00);
            $table->integer('sort_order')->default(0);
            $table->timestamps();

            $table->unique(['move_id', 'code']);
            $table->index(['move_id', 'sort_order']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bags');
    }
};
