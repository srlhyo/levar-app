<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Item extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $fillable = [
        'move_id',
        'bag_id',
        'title',
        'notes',
        'weight_kg',
        'volume_cm3',
        'dimensions',
        'section',
        'category',
        'fragile',
        'decision',
        'packed_at',
        'sort_order',
        'location_hint',
        'photo_url',
        'thumbnail_url',
    ];

    protected $casts = [
        'weight_kg' => 'float',
        'volume_cm3' => 'float',
        'fragile' => 'boolean',
        'packed_at' => 'datetime',
    ];

    protected $attributes = [
        'decision' => 'undecided',
    ];

    protected $appends = [
        'is_packed',
    ];

    public function move()
    {
        return $this->belongsTo(Move::class);
    }

    public function bag()
    {
        return $this->belongsTo(Bag::class);
    }

    public function media()
    {
        return $this->hasMany(ItemMedia::class);
    }

    public function decisionLogs()
    {
        return $this->hasMany(DecisionLog::class);
    }

    public function scopeForMove($query, Move $move)
    {
        return $query->where('move_id', $move->id);
    }

    public function getIsPackedAttribute(): bool
    {
        return !is_null($this->packed_at);
    }
}
