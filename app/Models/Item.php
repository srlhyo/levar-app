<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Storage;

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

    public function getPhotoUrlAttribute($value): ?string
    {
        return $this->resolveMediaUrl($value);
    }

    public function getThumbnailUrlAttribute($value): ?string
    {
        return $this->resolveMediaUrl($value);
    }

    protected function resolveMediaUrl(?string $value): ?string
    {
        $path = $this->normalizeMediaPath($value);
        if (!$path) {
            return null;
        }

        $disk = $this->mediaDisk();

        if (!Storage::disk($disk)->exists($path)) {
            return null;
        }

        return Storage::disk($disk)->url($path);
    }

    protected function normalizeMediaPath(?string $value): ?string
    {
        if (!$value) {
            return null;
        }

        $path = parse_url($value, PHP_URL_PATH) ?? $value;
        if (!$path) {
            return null;
        }

        $path = ltrim($path, '/');

        if (str_starts_with($path, 'storage/')) {
            $path = substr($path, strlen('storage/'));
        }

        return $path;
    }

    protected function mediaDisk(): string
    {
        $defaultDisk = config('filesystems.default', 'public');

        return $defaultDisk === 'local' ? 'public' : $defaultDisk;
    }
}
