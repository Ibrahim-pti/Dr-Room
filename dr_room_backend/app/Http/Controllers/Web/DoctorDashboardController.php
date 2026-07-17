<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DoctorDashboardController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $doctor = $user->doctor;

        if (!$doctor) {
            // If they somehow got here without a doctor record, redirect or handle it
            return redirect()->route('doctor.login')->withErrors(['error' => 'No doctor profile found.']);
        }

        // Fetch appointments specific to this doctor
        $todayAppointments = $doctor->appointments()->today()->count();
        $totalPatients = $doctor->total_patients;
        
        // Upcoming appointments
        $upcomingAppointments = $doctor->appointments()
            ->upcoming()
            ->with('patient')
            ->orderBy('appointment_date', 'asc')
            ->take(5)
            ->get();

        return view('doctor.dashboard.index', compact(
            'user', 
            'doctor', 
            'todayAppointments', 
            'totalPatients',
            'upcomingAppointments'
        ));
    }
}
