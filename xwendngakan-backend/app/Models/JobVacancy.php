<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JobVacancy extends Model
{
    use HasFactory;

    protected $fillable = [
        'institution_id',
        'institution_name',
        'institution_logo',
        'title',
        'category',
        'subject',
        'education_level',
        'employment_type',
        'city',
        'salary_range',
        'gender',
        'experience_years',
        'description',
        'requirements',
        'contact_phone',
        'contact_whatsapp',
        'contact_email',
        'is_active',
        'is_approved',
        'views_count',
    ];

    protected $casts = [
        'is_active'   => 'boolean',
        'is_approved' => 'boolean',
        'views_count' => 'integer',
    ];

    public function institution()
    {
        return $this->belongsTo(Institution::class);
    }

    public function toArray()
    {
        $array = parent::toArray();
        if (!empty($array['institution_logo']) && !str_starts_with($array['institution_logo'], 'http')) {
            $path = ltrim($array['institution_logo'], '/');
            if (!str_starts_with($path, 'storage/')) {
                $path = 'storage/' . $path;
            }
            $array['institution_logo'] = url($path);
        }
        return $array;
    }
}
