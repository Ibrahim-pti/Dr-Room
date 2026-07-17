<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'phone' => 'required|string',
            'password' => 'required|string',
        ]);

        $user = User::where('phone', $request->phone)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'ژمارە مۆبایل یان وشەی تێپەڕ هەڵەیە'
            ], 401);
        }

        $otp = rand(1000, 9999);
        $user->otp_code = $otp;
        $user->otp_expires_at = now()->addMinutes(5);
        $user->save();

        return response()->json([
            'message' => 'کۆدەکە نێردرا بۆ مۆبایلەکەت',
            'otp' => $otp, // For dev purposes
            'phone' => $user->phone
        ]);
    }

    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|unique:users',
            'password' => 'required|string|min:6',
        ]);

        $otp = rand(1000, 9999);

        $user = User::create([
            'name' => $request->name,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'is_admin' => false,
            'is_doctor' => false,
            'otp_code' => $otp,
            'otp_expires_at' => now()->addMinutes(5)
        ]);

        return response()->json([
            'message' => 'هەژمارەکەت دروستکرا، تکایە کۆدەکە بنووسە',
            'otp' => $otp, // For dev purposes
            'phone' => $user->phone
        ], 201);
    }

    public function verifyOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|string',
            'otp_code' => 'required|string'
        ]);

        $user = User::where('phone', $request->phone)->first();

        if (!$user || $user->otp_code !== $request->otp_code || now()->gt($user->otp_expires_at)) {
            return response()->json([
                'message' => 'کۆدەکە هەڵەیە یان بەسەرچووە'
            ], 400);
        }

        // Clear OTP
        $user->otp_code = null;
        $user->otp_expires_at = null;
        $user->save();

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'phone' => $user->phone,
                'is_admin' => $user->is_admin,
            ]
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logged out successfully'
        ]);
    }

    public function user(Request $request)
    {
        return response()->json([
            'user' => $request->user()
        ]);
    }
}
