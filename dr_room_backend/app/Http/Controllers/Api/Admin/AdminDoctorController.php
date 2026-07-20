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
        $doctors = User::where('role', 'doctor')->with('doctor')->get();
        return response()->json($doctors);
    }

    public function approve($id)
    {
        $user = User::where('role', 'doctor')->findOrFail($id);
        $user->update(['status' => 'approved']);
        
        if (!$user->doctor) {
            $user->doctor()->create([
                'specialty' => 'General', // Default, they can update later
                // Add other default doctor fields here if necessary
            ]);
        }

        return response()->json(['message' => 'Doctor approved successfully', 'user' => $user->load('doctor')]);
    }

    public function reject($id)
    {
        $user = User::where('role', 'doctor')->findOrFail($id);
        $user->update(['status' => 'rejected']);
        
        return response()->json(['message' => 'Doctor rejected successfully', 'user' => $user]);
    }

    public function destroy($id)
    {
        $user = User::where('role', 'doctor')->findOrFail($id);
        if ($user->doctor) {
            $user->doctor->delete();
        }
        $user->delete();

        return response()->json(null, 204);
    }
}
