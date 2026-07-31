<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class EmergencyReelController extends Controller
{
    public function index()
    {
        // High quality public MP4 videos from Flutter docs to serve as placeholders
        $reels = [
            [
                'id' => 1,
                'title' => 'CPR Instructions',
                'description' => 'Learn how to perform Hands-Only CPR on an adult.',
                'video_url' => 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                'author' => 'Dr. Room First Aid',
                'likes' => 1240,
                'shares' => 300,
            ],
            [
                'id' => 2,
                'title' => 'Heimlich Maneuver',
                'description' => 'What to do when someone is choking.',
                'video_url' => 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                'author' => 'Dr. Room First Aid',
                'likes' => 892,
                'shares' => 150,
            ],
            [
                'id' => 3,
                'title' => 'Treating Burns',
                'description' => 'Immediate steps for treating minor burns at home.',
                'video_url' => 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                'author' => 'Dr. Room First Aid',
                'likes' => 2050,
                'shares' => 420,
            ],
        ];

        return response()->json($reels);
    }
}
