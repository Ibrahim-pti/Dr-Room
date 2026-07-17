<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Doctor extends Model
{
    protected $fillable = [
        'user_id',
        'specialty',
        'image_path',
        'bio',
        'rating',
        'total_reviews',
        'consultation_fee',
        'experience_years',
        'phone',
        'available_days',
        'is_approved',
    ];

    protected $casts = [
        'available_days' => 'array',
        'rating' => 'decimal:1',
        'is_approved' => 'boolean',
    ];

    /** The user account linked to this doctor */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /** Appointments belonging to this doctor */
    public function appointments()
    {
        return $this->hasMany(Appointment::class);
    }

    /** Total unique patients this doctor has seen */
    public function getTotalPatientsAttribute(): int
    {
        return $this->appointments()->distinct('patient_id')->count('patient_id');
    }

    /** Today's appointment count */
    public function getTodayAppointmentsCountAttribute(): int
    {
        return $this->appointments()->today()->count();
    }
}
