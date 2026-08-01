<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DoctorProfileController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $doctor = $user->doctor;
        return view('doctor.profile.index', compact('user', 'doctor'));
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $doctor = $user->doctor;

        $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:20',
            'specialty' => 'nullable|string|max:255',
            'bio' => 'nullable|string',
            'consultation_fee' => 'nullable|numeric|min:0',
            'video_type' => 'nullable|in:youtube,uploaded',
            'youtube_url' => 'nullable|url',
            'video_file' => 'nullable|mimes:mp4,mov,ogg,qt|max:50000', // max 50MB
        ]);

        $user->update([
            'name' => $request->name,
            'phone' => $request->phone,
        ]);

        if ($doctor) {
            $updateData = [
                'specialty' => $request->specialty,
                'bio' => $request->bio,
                'consultation_fee' => $request->consultation_fee,
            ];

            if ($request->has('video_type')) {
                $updateData['video_type'] = $request->video_type;
                if ($request->video_type === 'youtube') {
                    $updateData['video_url'] = $request->youtube_url;
                } elseif ($request->video_type === 'uploaded' && $request->hasFile('video_file')) {
                    $path = $request->file('video_file')->store('doctor_videos', 'public');
                    $updateData['video_url'] = '/storage/' . $path;
                }
            }

            try {
                $tr = new \Stichoza\GoogleTranslate\GoogleTranslate();
                if ($request->specialty) {
                    $updateData['specialty_en'] = $tr->setTarget('en')->translate($request->specialty);
                    $updateData['specialty_ar'] = $tr->setTarget('ar')->translate($request->specialty);
                }
                if ($request->bio) {
                    $updateData['bio_en'] = $tr->setTarget('en')->translate($request->bio);
                    $updateData['bio_ar'] = $tr->setTarget('ar')->translate($request->bio);
                }
            } catch (\Exception $e) {
                \Illuminate\Support\Facades\Log::error('Translation failed: ' . $e->getMessage());
            }

            $doctor->update($updateData);
        }

        return back()->with('success', 'زانیارییەکانی پڕۆفایل نوێکرانەوە.');
    }
}
