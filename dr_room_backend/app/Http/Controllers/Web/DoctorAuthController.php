<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Doctor;

class DoctorAuthController extends Controller
{
    public function showLogin()
    {
        if (Auth::check() && Auth::user()->is_doctor) {
            return redirect('/doctor/dashboard');
        }
        return view('doctor.auth.login');
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        if (Auth::attempt($credentials)) {
            $user = Auth::user();
            if ($user->is_doctor) {
                $request->session()->regenerate();
                return redirect()->intended('/doctor/dashboard');
            } else {
                Auth::logout();
                return back()->withErrors([
                    'email' => 'تۆ دەسەڵاتی دکتۆریت نییە.',
                ]);
            }
        }

        return back()->withErrors([
            'email' => 'زانیارییەکان هەڵەن یان بوونیان نییە.',
        ])->onlyInput('email');
    }

    public function showRegister()
    {
        if (Auth::check() && Auth::user()->is_doctor) {
            return redirect('/doctor/dashboard');
        }
        return view('doctor.auth.register');
    }

    public function register(Request $request)
    {
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
            'specialty' => ['required', 'string', 'max:255'],
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'is_doctor' => true,
        ]);

        Doctor::create([
            'user_id' => $user->id,
            'specialty' => $request->specialty,
        ]);

        Auth::login($user);

        return redirect('/doctor/dashboard');
    }

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect('/doctor/login');
    }
}
