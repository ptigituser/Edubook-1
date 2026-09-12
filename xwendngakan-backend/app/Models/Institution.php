<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Institution extends Model
{
    protected $fillable = [
        'user_id', 'nku', 'nkbd', 'nen', 'nar', 'type', 'country', 'city',
        'web', 'phone', 'email', 'addr', 'desc', 'desc_en', 'desc_ar', 'desc_kbd',
        'lat', 'lng',
        'colleges', 'depts', 'tuition_plans',
        'fee', 'meal', 'uniform', 'books', 'level',
        'kg_fee', 'kg_meal', 'kg_uniform', 'kg_age', 'kg_hours',
        'fb', 'ig', 'tg', 'wa', 'tk', 'yt',
        'logo', 'img', 'video',
        'founded_year', 'students_count', 'views',
        'approved', 'is_premium', 'manager_name',
    ];

    protected $casts = [
        'approved'       => 'boolean',
        'is_premium'     => 'boolean',
        'tuition_plans'  => 'array',
        'lat' => 'double',
        'lng' => 'double',
        'founded_year' => 'integer',
        'students_count' => 'integer',
        'views' => 'integer',
    ];

    // Map snake_case DB columns to camelCase for Flutter JSON
    public function toArray()
    {
        $array = parent::toArray();
        $array['kgAge'] = $array['kg_age'] ?? '';
        $array['kgHours'] = $array['kg_hours'] ?? '';

        // Ensure file paths start with /storage/ for API consumers
        foreach (['logo', 'img', 'video'] as $key) {
            if (!empty($array[$key]) && !str_starts_with($array[$key], 'http') && !str_starts_with($array[$key], '/storage/')) {
                $array[$key] = '/storage/' . ltrim($array[$key], '/');
            }
        }

        // Rating stats
        $array['rating_avg'] = isset($this->attributes['reviews_avg_rating'])
            ? round((float) $this->attributes['reviews_avg_rating'], 1)
            : ($this->relationLoaded('reviews') 
                ? round((float) ($this->reviews->avg('rating') ?? 0), 1) 
                : round((float) ($this->reviews()->avg('rating') ?? 0), 1));

        $array['reviews_count'] = isset($this->attributes['reviews_count'])
            ? (int) $this->attributes['reviews_count']
            : ($this->relationLoaded('reviews') 
                ? $this->reviews->count() 
                : $this->reviews()->count());

        return $array;
    }


    /**
     * Get posts for this institution.
     */
    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }

    /**
     * Get reviews for this institution.
     */
    public function reviews(): HasMany
    {
        return $this->hasMany(Review::class)->latest();
    }

    /**
     * Get chat conversations for this institution.
     */
    public function conversations(): HasMany
    {
        return $this->hasMany(Conversation::class)->latest('last_message_at');
    }
}
