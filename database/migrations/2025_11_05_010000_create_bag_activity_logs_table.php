<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('bag_activity_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('move_id')->constrained()->cascadeOnDelete();
            $table->foreignId('bag_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('item_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->string('action', 40);
            $table->json('meta')->nullable();
            $table->timestamps();
            $table->index(['bag_id', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bag_activity_logs');
    }
};
