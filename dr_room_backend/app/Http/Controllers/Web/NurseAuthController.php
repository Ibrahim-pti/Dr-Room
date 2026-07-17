<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Nurse;

class NurseAuthController extends Controller
{
    public function showLogin()
    {
        if (Auth::check() && Auth::user()->is_nurse) {
            return redirect('/nurse/dashboard');
        }
        return view('nurse.auth.login');
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        if (Auth::attempt($credentials)) {
            $user = Auth::user();
            if ($user->is_nurse) {
                $request->session()->regenerate();
                return redirect()->intended('/nurse/dashboard');
            } else {
                Auth::logout();
                return back()->withErrors([
                    'email' => 'تۆ دەسەڵاتی پەرستاریت نییە.',
                ]);
            }
        }

        return back()->withErrors([
            'email' => 'زانیارییەکان هەڵەن یان بوونیان نییە.',
        ])->onlyInput('email');
    }

    public function showRegister()
    {
        if (Auth::check() && Auth::user()->is_nurse) {
            return redirect('/nurse/dashboard');
        }
        return view('nurse.auth.register');
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
            'is_nurse' => true,
        ]);

        Nurse::create([
            'user_id' => $user->id,
            'specialty' => $request->specialty,
        ]);

        Auth::login($user);

        return redirect('/nurse/dashboard');
    }

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect('/nurse/login');
    }
}
