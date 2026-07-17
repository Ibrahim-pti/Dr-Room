<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DoctorProfileController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $doctor = $user->doctor;
        return view('doctor.profile.index', compact('user', 'doctor'));
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $doctor = $user->doctor;

        $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:20',
            'specialty' => 'nullable|string|max:255',
            'bio' => 'nullable|string',
            'consultation_fee' => 'nullable|numeric|min:0',
        ]);

        $user->update([
            'name' => $request->name,
            'phone' => $request->phone,
        ]);

        if ($doctor) {
            $doctor->update([
                'specialty' => $request->specialty,
                'bio' => $request->bio,
                'consultation_fee' => $request->consultation_fee,
            ]);
        }

        return back()->with('success', 'زانیارییەکانی پڕۆفایل نوێکرانەوە.');
    }
}
