<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PharmacyDashboardController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        
        // Placeholder stats for the dashboard
        $todayOrders = 5;
        $pendingPrescriptions = 12;
        $totalCustomers = 150;
        $lowStockItems = 8;
        
        return view('pharmacy.dashboard.index', compact(
            'user', 
            'todayOrders', 
            'pendingPrescriptions', 
            'totalCustomers',
            'lowStockItems'
        ));
    }
}
