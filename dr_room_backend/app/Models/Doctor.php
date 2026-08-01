<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Doctor extends Model
{
    protected $guarded = [];

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

    /** Doctor Services (Visit Types / Treated Diseases) */
    public function services()
    {
        return $this->hasMany(DoctorService::class);
    }

    /** Doctor Schedules (Available Times) */
    public function schedules()
    {
        return $this->hasMany(DoctorSchedule::class);
    }
}
