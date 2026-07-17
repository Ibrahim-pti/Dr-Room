<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Doctor;
use App\Models\User;

class AdminDoctorController extends Controller
{
    public function index()
    {
        $doctors = Doctor::with('user')->get();
        return response()->json($doctors);
    }

    public function approve($id)
    {
        $doctor = Doctor::with('user')->findOrFail($id);
        $doctor->update(['is_approved' => true]);
        
        if ($doctor->user) {
            $doctor->user->update(['is_doctor' => true]);
        }

        return response()->json(['message' => 'Doctor approved successfully', 'doctor' => $doctor]);
    }

    public function reject($id)
    {
        $doctor = Doctor::with('user')->findOrFail($id);
        $doctor->update(['is_approved' => false]);
        
        if ($doctor->user) {
            $doctor->user->update(['is_doctor' => false]);
        }

        return response()->json(['message' => 'Doctor rejected successfully', 'doctor' => $doctor]);
    }

    public function destroy($id)
    {
        $doctor = Doctor::findOrFail($id);
        $doctor->delete();

        return response()->json(null, 204);
    }
}
