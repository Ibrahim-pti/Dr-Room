<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Nurse extends Model
{
    protected $fillable = [
        'user_id',
        'specialty',
        'image_path',
        'bio',
        'phone',
        'is_approved',
    ];

    protected $casts = [
        'is_approved' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function nurseAppointments()
    {
        return $this->hasMany(NurseAppointment::class);
    }
}
