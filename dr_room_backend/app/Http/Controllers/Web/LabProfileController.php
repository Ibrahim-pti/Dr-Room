<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LabProfileController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $lab = $user->lab;
        return view('lab.profile.index', compact('user', 'lab'));
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $lab = $user->lab;

        $request->validate([
            'name' => 'required|string|max:255',
            'name_en' => 'nullable|string|max:255',
            'name_ar' => 'nullable|string|max:255',
            'phone' => 'required|string|max:20',
            'license_number' => 'nullable|string|max:255',
            'about_us' => 'nullable|string',
            'about_us_en' => 'nullable|string',
            'about_us_ar' => 'nullable|string',
            'location' => 'nullable|string|max:500',
            'location_en' => 'nullable|string|max:500',
            'location_ar' => 'nullable|string|max:500',
            'equipment_level' => 'nullable|string|max:255',
            'home_sample_collection' => 'nullable|boolean',
            'image' => 'nullable|image|max:5120',
        ]);

        $user->update([
            'name' => $request->name,
            'name_en' => $request->name_en,
            'name_ar' => $request->name_ar,
            'phone' => $request->phone,
        ]);

        if ($lab) {
            $updateData = [
                'phone' => $request->phone,
                'license_number' => $request->license_number,
                'about_us' => $request->about_us,
                'about_us_en' => $request->about_us_en,
                'about_us_ar' => $request->about_us_ar,
                'location' => $request->location,
                'location_en' => $request->location_en,
                'location_ar' => $request->location_ar,
                'equipment_level' => $request->equipment_level,
                'home_sample_collection' => $request->has('home_sample_collection') ? true : false,
            ];

            if ($request->hasFile('image')) {
                $path = $request->file('image')->store('lab_images', 'public');
                $updateData['image_path'] = '/storage/' . $path;
            }

            try {
                $tr = new \Stichoza\GoogleTranslate\GoogleTranslate();
                
                if ($request->about_us && !$request->about_us_en) {
                    $updateData['about_us_en'] = $tr->setTarget('en')->translate($request->about_us);
                }
                if ($request->about_us && !$request->about_us_ar) {
                    $updateData['about_us_ar'] = $tr->setTarget('ar')->translate($request->about_us);
                }
                
                if ($request->location && !$request->location_en) {
                    $updateData['location_en'] = $tr->setTarget('en')->translate($request->location);
                }
                if ($request->location && !$request->location_ar) {
                    $updateData['location_ar'] = $tr->setTarget('ar')->translate($request->location);
                }
            } catch (\Exception $e) {
                // Translation failed, ignore
            }

            $lab->update($updateData);
        }

        return redirect()->route('lab.dashboard')->with('success', 'زانیارییەکانی پرۆفایل بە سەرکەوتوویی نوێکرانەوە.');
    }
}
