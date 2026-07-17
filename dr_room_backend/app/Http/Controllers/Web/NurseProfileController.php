<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NurseProfileController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $nurse = $user->nurse;
        return view('nurse.profile.index', compact('user', 'nurse'));
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $nurse = $user->nurse;

        $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:20',
            'specialty' => 'nullable|string|max:255',
            'bio' => 'nullable|string',
        ]);

        $user->update([
            'name' => $request->name,
            'phone' => $request->phone,
        ]);

        if ($nurse) {
            $nurse->update([
                'specialty' => $request->specialty,
                'bio' => $request->bio,
            ]);
        }

        return back()->with('success', 'زانیارییەکانی پڕۆفایل نوێکرانەوە.');
    }
}
