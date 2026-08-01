<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DoctorTimeOffController extends Controller
{
    /**
     * Store a new time off.
     */
    public function store(Request $request)
    {
        $request->validate([
            'start_datetime' => 'required|date',
            'end_datetime' => 'required|date|after:start_datetime',
            'reason' => 'nullable|string|max:255',
        ]);

        $doctor = Auth::user()->doctor;

        $doctor->timeOffs()->create([
            'start_datetime' => $request->start_datetime,
            'end_datetime' => $request->end_datetime,
            'reason' => $request->reason,
        ]);

        // Bust the availability cache since slots changed
        \Illuminate\Support\Facades\Cache::forget("doctor:{$doctor->id}:availability");

        return redirect()->back()->with('success', __('Time off added successfully.'));
    }

    /**
     * Remove a time off.
     */
    public function destroy($id)
    {
        $doctor = Auth::user()->doctor;

        $timeOff = $doctor->timeOffs()->findOrFail($id);
        $timeOff->delete();

        // Bust the availability cache since slots changed
        \Illuminate\Support\Facades\Cache::forget("doctor:{$doctor->id}:availability");

        return redirect()->back()->with('success', __('Time off deleted successfully.'));
    }
}

