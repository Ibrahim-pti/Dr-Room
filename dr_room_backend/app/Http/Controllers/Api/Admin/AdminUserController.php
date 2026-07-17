<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;

class AdminUserController extends Controller
{
    public function index()
    {
        $users = User::where('is_admin', false)->where('is_doctor', false)->get();
        return response()->json($users);
    }

    public function block($id)
    {
        $user = User::findOrFail($id);
        $user->update(['is_blocked' => true]);

        return response()->json(['message' => 'User blocked successfully', 'user' => $user]);
    }

    public function unblock($id)
    {
        $user = User::findOrFail($id);
        $user->update(['is_blocked' => false]);

        return response()->json(['message' => 'User unblocked successfully', 'user' => $user]);
    }
}
