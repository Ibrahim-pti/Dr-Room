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
            $doctors = Doctor::select('id', 'name', 'specialization', 'image', 'experience_years', 'rating', 'fee')->limit(10)->get();
            $pharmacies = Pharmacy::select('id', 'name', 'address', 'image', 'rating', 'delivery_time', 'delivery_fee', 'is_open')->limit(10)->get();
            $medications = Medication::with('user:id,name')->select('id', 'user_id', 'name', 'price', 'image_path')->limit(10)->get()->map(function($med) {
                return [
                    'id' => $med->id,
                    'pharmacy_id' => $med->user_id,
                    'name' => $med->name,
                    'price' => $med->price,
                    'image' => $med->image_path,
                    'pharmacy' => ['name' => $med->user ? $med->user->name : 'Pharmacy']
                ];
            });
            $labs = Lab::select('id', 'name', 'address', 'image', 'rating', 'is_open')->limit(10)->get();

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
            ->with('user:id,name')
            ->select('id', 'user_id', 'name', 'price', 'image_path')
            ->limit(10)
            ->get()->map(function($med) {
                return [
                    'id' => $med->id,
                    'pharmacy_id' => $med->user_id,
                    'name' => $med->name,
                    'price' => $med->price,
                    'image' => $med->image_path,
                    'pharmacy' => ['name' => $med->user ? $med->user->name : 'Pharmacy']
                ];
            });

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
