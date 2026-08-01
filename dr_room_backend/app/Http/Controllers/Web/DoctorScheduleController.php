<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\DoctorSchedule;

class DoctorScheduleController extends Controller
{
    public function index()
    {
        $doctor = Auth::user()->doctor;
        $schedules = $doctor->schedules;
        return view('doctor.schedules.index', compact('schedules'));
    }

    public function store(Request $request)
    {
        $doctor = Auth::user()->doctor;
        $request->validate([
            'day_of_week' => 'required|string',
            'start_time' => 'required',
            'end_time' => 'required',
        ]);

        $doctor->schedules()->create([
            'day_of_week' => $request->day_of_week,
            'start_time' => $request->start_time,
            'end_time' => $request->end_time,
        ]);

        return back()->with('success', 'کاتی نوێ بە سەرکەوتوویی دیاریکرا.');
    }

    public function destroy($id)
    {
        $doctor = Auth::user()->doctor;
        $schedule = $doctor->schedules()->findOrFail($id);
        $schedule->delete();

        return back()->with('success', 'کاتەکە سڕایەوە.');
    }
}
