<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Banner;
use Illuminate\Support\Facades\Storage;

class BannerController extends Controller
{
    public function index()
    {
        return Banner::orderBy('sort_order')->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'nullable|string',
            'image' => 'required|image',
            'link_url' => 'nullable|url',
            'is_active' => 'boolean',
            'sort_order' => 'integer'
        ]);

        $path = $request->file('image')->store('banners', 'public');

        $banner = Banner::create([
            'title' => $request->title,
            'image_path' => $path,
            'link_url' => $request->link_url,
            'is_active' => $request->is_active ?? true,
            'sort_order' => $request->sort_order ?? 0,
        ]);

        return response()->json($banner, 201);
    }

    public function show(string $id)
    {
        return Banner::findOrFail($id);
    }

    public function update(Request $request, string $id)
    {
        $banner = Banner::findOrFail($id);
        
        $request->validate([
            'title' => 'nullable|string',
            'image' => 'nullable|image',
            'link_url' => 'nullable|url',
            'is_active' => 'boolean',
            'sort_order' => 'integer'
        ]);

        if ($request->hasFile('image')) {
            Storage::disk('public')->delete($banner->image_path);
            $banner->image_path = $request->file('image')->store('banners', 'public');
        }

        $banner->update($request->except('image'));

        return response()->json($banner);
    }

    public function destroy(string $id)
    {
        $banner = Banner::findOrFail($id);
        Storage::disk('public')->delete($banner->image_path);
        $banner->delete();

        return response()->json(null, 204);
    }
}
