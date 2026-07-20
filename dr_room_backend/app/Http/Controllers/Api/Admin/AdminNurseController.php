<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Nurse;

use App\Models\User;

class AdminNurseController extends Controller
{
    public function index()
    {
        $nurses = User::where('role', 'nurse')->with('nurse')->get();
        return response()->json($nurses);
    }

    public function approve($id)
    {
        $user = User::where('role', 'nurse')->findOrFail($id);
        $user->update(['status' => 'approved']);

        if (!$user->nurse) {
            $user->nurse()->create([
                // Add any default nurse fields if necessary
            ]);
        }

        return response()->json(['message' => 'Nurse approved successfully', 'user' => $user->load('nurse')]);
    }

    public function reject($id)
    {
        $user = User::where('role', 'nurse')->findOrFail($id);
        $user->update(['status' => 'rejected']);

        return response()->json(['message' => 'Nurse rejected successfully', 'user' => $user]);
    }

    public function destroy($id)
    {
        $user = User::where('role', 'nurse')->findOrFail($id);
        if ($user->nurse) {
            $user->nurse->delete();
        }
        $user->delete();

        return response()->json(null, 204);
    }
}
