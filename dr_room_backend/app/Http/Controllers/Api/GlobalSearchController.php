<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Doctor;
use App\Models\Pharmacy;
use App\Models\Medication;
use App\Models\Lab;

class GlobalSearchController extends Controller
{
    public function search(Request $request)
    {
        $query = $request->input('q');

        if (!$query) {
            return response()->json([
                'status' => 'success',
                'data' => [
                    'doctors' => [],
                    'pharmacies' => [],
                    'medications' => [],
                    'labs' => []
                ]
            ]);
        }

        $doctors = Doctor::where('name', 'LIKE', "%{$query}%")
            ->orWhere('specialization', 'LIKE', "%{$query}%")
            ->select('id', 'name', 'specialization', 'image', 'experience_years', 'rating', 'fee')
            ->limit(10)
            ->get();

        $pharmacies = Pharmacy::where('name', 'LIKE', "%{$query}%")
            ->select('id', 'name', 'address', 'image', 'rating', 'delivery_time', 'delivery_fee', 'is_open')
            ->limit(10)
            ->get();

        $medications = Medication::where('name', 'LIKE', "%{$query}%")
            ->orWhere('description', 'LIKE', "%{$query}%")
            ->with('pharmacy:id,name')
            ->select('id', 'pharmacy_id', 'name', 'price', 'image', 'requires_prescription', 'is_available')
            ->limit(10)
            ->get();

        $labs = Lab::where('name', 'LIKE', "%{$query}%")
            ->select('id', 'name', 'address', 'image', 'rating', 'is_open')
            ->limit(10)
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => [
                'doctors' => $doctors,
                'pharmacies' => $pharmacies,
                'medications' => $medications,
                'labs' => $labs
            ]
        ]);
    }
}
