<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;

class DoctorScheduleController extends Controller
{
    public function index()
    {
        $doctor = Auth::user()->doctor;
        $schedules = $doctor->schedules;
        return view('doctor.schedules.index', compact('schedules'));
    }

    private const DAYS = [
        'Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
    ];

    public function store(Request $request)
    {
        $doctor = Auth::user()->doctor;

        $request->validate([
            'day_of_week' => ['required', 'string', Rule::in(self::DAYS)],
            'start_time' => 'required|date_format:H:i',
            'end_time' => 'required|date_format:H:i|after:start_time',
            'slot_minutes' => 'required|integer|min:5|max:180',
        ]);

        $start = $request->start_time;
        $end = $request->end_time;

        // Two shifts that overlap would generate the same slot twice, so the
        // doctor is told to merge them instead.
        $clash = $doctor->schedules()
            ->where('day_of_week', $request->day_of_week)
            ->where(fn ($q) => $q->where('start_time', '<', $end)
                ->where('end_time', '>', $start))
            ->exists();

        if ($clash) {
            return back()->with('error', 'ئەم کاتە لەگەڵ کاتێکی تۆمارکراوی هەمان ڕۆژ تێکەڵ دەبێت.');
        }

        $doctor->schedules()->create([
            'day_of_week' => $request->day_of_week,
            'start_time' => $start,
            'end_time' => $end,
            'slot_minutes' => $request->slot_minutes,
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
