<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Stichoza\GoogleTranslate\GoogleTranslate;

class TranslateController extends Controller
{
    public function translate(Request $request)
    {
        $request->validate([
            'text' => 'required|string',
        ]);

        $text = $request->text;

        try {
            $tr = new GoogleTranslate();
            $en = $tr->setTarget('en')->translate($text);
            $ar = $tr->setTarget('ar')->translate($text);
            $ckb = $tr->setTarget('ckb')->translate($text);

            return response()->json([
                'success' => true,
                'translations' => [
                    'en' => $en,
                    'ar' => $ar,
                    'ckb' => $ckb,
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Translation failed: ' . $e->getMessage()
            ], 500);
        }
    }
}
