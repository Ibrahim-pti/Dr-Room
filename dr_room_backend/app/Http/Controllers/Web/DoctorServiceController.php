<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\DoctorService;
use Stichoza\GoogleTranslate\GoogleTranslate;

class DoctorServiceController extends Controller
{
    public function index()
    {
        $doctor = Auth::user()->doctor;
        $services = $doctor->services;
        return view('doctor.services.index', compact('services'));
    }

    public function store(Request $request)
    {
        $doctor = Auth::user()->doctor;
        $request->validate([
            'name_ckb' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
        ]);

        $name_ckb = $request->name_ckb;
        $name_en = $request->name_en;
        $name_ar = $request->name_ar;

        // Auto-translate if empty
        if (!$name_en || !$name_ar) {
            try {
                $tr = new GoogleTranslate();
                if (!$name_en) $name_en = $tr->setTarget('en')->translate($name_ckb);
                if (!$name_ar) $name_ar = $tr->setTarget('ar')->translate($name_ckb);
            } catch (\Exception $e) {
                \Illuminate\Support\Facades\Log::error('Service Translation failed: ' . $e->getMessage());
            }
        }

        $doctor->services()->create([
            'name_ckb' => $name_ckb,
            'name_en' => $name_en,
            'name_ar' => $name_ar,
            'price' => $request->price,
        ]);

        return back()->with('success', 'خزمەتگوزاری نوێ بە سەرکەوتوویی زیادکرا.');
    }

    public function destroy($id)
    {
        $doctor = Auth::user()->doctor;
        $service = $doctor->services()->findOrFail($id);
        $service->delete();

        return back()->with('success', 'خزمەتگوزاریەکە سڕایەوە.');
    }
}
