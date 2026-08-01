<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DoctorTimeOff extends Model
{
    protected $guarded = [];

    protected $casts = [
        'start_datetime' => 'datetime',
        'end_datetime' => 'datetime',
    ];

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }
}