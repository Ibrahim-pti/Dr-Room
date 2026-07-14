<?php

use Illuminate\Support\Facades\Route;

Route::get('/{locale?}', function ($locale = 'ckb') {
    if (!in_array($locale, ['en', 'ar', 'ckb'])) {
        abort(404);
    }
    app()->setLocale($locale);
    return view('welcome', ['locale' => $locale]);
});
