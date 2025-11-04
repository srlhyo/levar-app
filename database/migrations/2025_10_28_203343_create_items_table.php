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
        Schema::create('items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('move_id')->constrained()->cascadeOnDelete();
            $table->foreignId('bag_id')->nullable()->constrained('bags')->nullOnDelete();
            $table->string('title', 160);
            $table->text('notes')->nullable();
            $table->decimal('weight_kg', 5, 2)->nullable();
            $table->string('dimensions', 80)->nullable();
            $table->enum('section', ['living_room', 'kitchen', 'bedroom', 'office', 'bathroom', 'storage', 'other'])->default('other');
            $table->string('category', 80)->nullable();
            $table->boolean('fragile')->default(false);
            $table->enum('decision', ['undecided', 'pending', 'yes', 'no'])->default('undecided');
            $table->timestamp('packed_at')->nullable();
            $table->integer('sort_order')->default(0);
            $table->string('location_hint', 120)->nullable();
            $table->string('photo_url')->nullable();
            $table->string('thumbnail_url')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index('move_id');
            $table->index('decision');
            $table->index('bag_id');
            $table->index(['move_id', 'sort_order']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('items');
    }
};
