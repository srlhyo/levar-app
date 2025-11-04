<?php

namespace App\Models;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ItemMedia extends Model
{
    use HasFactory;

    protected $fillable = [
        'item_id',
        'disk',
        'path',
        'thumb_path',
        'status',
        'bytes',
        'width',
        'height',
        'mime',
        'uploaded_by',
    ];

    protected $casts = [
        'bytes' => 'int',
        'width' => 'int',
        'height' => 'int',
    ];

    public function item()
    {
        return $this->belongsTo(Item::class);
    }

    public function uploader()
    {
        return $this->belongsTo(User::class, 'uploaded_by');
    }
}
