<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BagSnapshot extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $fillable = [
        'move_id',
        'total_kg',
        'yes_kg',
        'pending_count',
        'decided_count',
        'yes_dimensions',
        'meta',
        'updated_at',
    ];

    protected $casts = [
        'total_kg' => 'float',
        'yes_kg' => 'float',
        'yes_dimensions' => 'array',
        'meta' => 'array',
        'updated_at' => 'datetime',
    ];

    public function move()
    {
        return $this->belongsTo(Move::class);
    }
}
