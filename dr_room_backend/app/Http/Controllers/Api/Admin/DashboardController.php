<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Doctor;
use App\Models\Appointment;

class DashboardController extends Controller
{
    public function index()
    {
        $totalUsers = User::where('is_admin', false)->where('is_doctor', false)->count();
        $totalDoctors = Doctor::count();
        $pendingDoctors = Doctor::where('is_approved', false)->count();
        $totalNurses = \App\Models\Nurse::count();
        $totalAppointments = Appointment::count();
        
        $recentAppointments = Appointment::with(['user', 'doctor.user'])
            ->orderBy('id', 'desc')
            ->take(5)
            ->get();

        return response()->json([
            'total_users' => $totalUsers,
            'total_doctors' => $totalDoctors,
            'pending_doctors' => $pendingDoctors,
            'total_nurses' => $totalNurses,
            'total_appointments' => $totalAppointments,
            'recent_appointments' => $recentAppointments,
        ]);
    }
}
