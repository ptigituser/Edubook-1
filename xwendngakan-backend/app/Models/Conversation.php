<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Conversation extends Model
{
    protected $fillable = [
        'institution_id',
        'user_id',
        'last_message',
        'last_message_at',
        'user_unread_count',
        'institution_unread_count',
    ];

    protected $casts = [
        'last_message_at' => 'datetime',
        'user_unread_count' => 'integer',
        'institution_unread_count' => 'integer',
    ];

    public function institution(): BelongsTo
    {
        return $this->belongsTo(Institution::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function messages(): HasMany
    {
        return $this->hasMany(Message::class)->oldest();
    }
}
