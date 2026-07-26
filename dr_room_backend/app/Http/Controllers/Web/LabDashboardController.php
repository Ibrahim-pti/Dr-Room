<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LabDashboardController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        
        return view('lab.dashboard.index', [
            'user' => $user,
        ]);
    }
}
