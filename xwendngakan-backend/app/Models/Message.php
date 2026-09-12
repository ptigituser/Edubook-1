<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Message extends Model
{
    protected $fillable = [
        'conversation_id',
        'sender_type',
        'sender_id',
        'message',
        'image',
        'is_read',
    ];

    protected $casts = [
        'is_read' => 'boolean',
    ];

    public function toArray()
    {
        $array = parent::toArray();
        if (!empty($array['image']) && !str_starts_with($array['image'], 'http') && !str_starts_with($array['image'], '/storage/')) {
            $array['image'] = '/storage/' . ltrim($array['image'], '/');
        }
        return $array;
    }

    public function conversation(): BelongsTo
    {
        return $this->belongsTo(Conversation::class);
    }

    public function sender(): BelongsTo
    {
        return $this->belongsTo(User::class, 'sender_id');
    }
}
