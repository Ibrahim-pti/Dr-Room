<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Nurse;

class AdminNurseController extends Controller
{
    public function index()
    {
        $nurses = Nurse::with('user')->get();
        return response()->json($nurses);
    }

    public function approve($id)
    {
        $nurse = Nurse::with('user')->findOrFail($id);
        $nurse->update(['is_approved' => true]);

        return response()->json(['message' => 'Nurse approved successfully', 'nurse' => $nurse]);
    }

    public function reject($id)
    {
        $nurse = Nurse::with('user')->findOrFail($id);
        $nurse->update(['is_approved' => false]);

        return response()->json(['message' => 'Nurse rejected successfully', 'nurse' => $nurse]);
    }

    public function destroy($id)
    {
        $nurse = Nurse::findOrFail($id);
        $nurse->delete();

        return response()->json(null, 204);
    }
}
