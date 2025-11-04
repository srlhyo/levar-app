<?php

namespace App\Models;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Move extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $fillable = [
        'user_id',
        'origin_country',
        'destination_country',
        'reserved_weight_kg',
        'reserved_volume_cm3',
        'settings',
    ];

    protected $casts = [
        'reserved_weight_kg' => 'float',
        'reserved_volume_cm3' => 'float',
        'settings' => 'array',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function bags()
    {
        return $this->hasMany(Bag::class);
    }

    public function items()
    {
        return $this->hasMany(Item::class);
    }

    public function snapshot()
    {
        return $this->hasOne(BagSnapshot::class);
    }
}
