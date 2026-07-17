<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Article;
use Illuminate\Support\Facades\Storage;

class ArticleController extends Controller
{
    public function index()
    {
        return Article::latest()->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string',
            'content' => 'required|string',
            'image' => 'nullable|image',
            'is_published' => 'boolean'
        ]);

        $path = null;
        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('articles', 'public');
        }

        $article = Article::create([
            'title' => $request->title,
            'content' => $request->content,
            'image_path' => $path,
            'is_published' => $request->is_published ?? true,
        ]);

        return response()->json($article, 201);
    }

    public function show(string $id)
    {
        return Article::findOrFail($id);
    }

    public function update(Request $request, string $id)
    {
        $article = Article::findOrFail($id);
        
        $request->validate([
            'title' => 'nullable|string',
            'content' => 'nullable|string',
            'image' => 'nullable|image',
            'is_published' => 'boolean'
        ]);

        if ($request->hasFile('image')) {
            if ($article->image_path) {
                Storage::disk('public')->delete($article->image_path);
            }
            $article->image_path = $request->file('image')->store('articles', 'public');
        }

        $article->update($request->except('image'));

        return response()->json($article);
    }

    public function destroy(string $id)
    {
        $article = Article::findOrFail($id);
        if ($article->image_path) {
            Storage::disk('public')->delete($article->image_path);
        }
        $article->delete();

        return response()->json(null, 204);
    }
}
