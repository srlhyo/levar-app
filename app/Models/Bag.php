<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bag extends Model
{
    use HasFactory;

    protected $fillable = [
        'move_id',
        'name',
        'code',
        'capacity_kg',
        'dimensions',
        'sort_order',
    ];

    protected $casts = [
        'capacity_kg' => 'float',
    ];

    public function move()
    {
        return $this->belongsTo(Move::class);
    }

    public function items()
    {
        return $this->hasMany(Item::class);
    }
}
