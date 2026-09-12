<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppFeedback extends Model
{
    protected $table = 'app_feedbacks';

    protected $fillable = [
        'user_id',
        'user_name',
        'user_phone',
        'rating',
        'feedback_type',
        'comment',
        'platform',
        'app_version',
        'device_info',
        'is_reviewed',
    ];

    protected $casts = [
        'rating'      => 'integer',
        'is_reviewed' => 'boolean',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
