<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\Banner;
use App\Models\Article;
use App\Models\AppNotification;
use App\Models\Category;

class AppController extends Controller
{
    public function home()
    {
        return response()->json([
            'banners' => Banner::where('is_active', true)->orderBy('sort_order')->get(),
            'categories' => Category::all(),
            'latest_articles' => Article::where('is_published', true)->latest()->take(5)->get(),
            'top_doctors' => \App\Models\Doctor::with('user:id,name,email,is_doctor')->orderBy('rating', 'desc')->take(5)->get(),
        ]);
    }

    public function banners()
    {
        return Banner::where('is_active', true)->orderBy('sort_order')->get();
    }

    public function articles()
    {
        return Article::where('is_published', true)->latest()->get();
    }

    public function notifications(Request $request)
    {
        $userId = $request->user() ? $request->user()->id : null;
        
        return AppNotification::whereNull('user_id')
            ->orWhere('user_id', $userId)
            ->latest()
            ->get();
    }

    public function doctors(Request $request)
    {
        $query = \App\Models\Doctor::with('user:id,name,email,is_doctor');

        if ($request->has('specialty')) {
            $query->where('specialty', $request->specialty);
        }

        return $query->get();
    }
}
