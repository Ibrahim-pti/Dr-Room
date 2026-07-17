<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AppController;
use App\Http\Controllers\Api\DoctorController;
use App\Http\Controllers\Api\AppointmentBookingController;
use App\Http\Controllers\Api\Admin\BannerController;
use App\Http\Controllers\Api\Admin\ArticleController;
use App\Http\Controllers\Api\Admin\NotificationController;
use App\Http\Controllers\Api\Admin\AppointmentController;
use App\Http\Controllers\Api\Admin\DashboardController;

Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/verify-otp', [AuthController::class, 'verifyOtp']);

// Public User App Routes
Route::get('/home', [AppController::class, 'home']);
Route::get('/banners', [AppController::class, 'banners']);
Route::get('/articles', [AppController::class, 'articles']);
Route::get('/notifications', [AppController::class, 'notifications']);
Route::get('/doctors', [AppController::class, 'doctors']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);

    // ─── Patient: Appointment Booking ──────────────────────────────────────
    Route::get('/appointments', [AppointmentBookingController::class, 'index']);
    Route::post('/appointments', [AppointmentBookingController::class, 'store']);
    Route::delete('/appointments/{id}', [AppointmentBookingController::class, 'destroy']);

    // ─── Doctor: Dashboard API ─────────────────────────────────────────────
    Route::middleware([\App\Http\Middleware\IsDoctor::class])->prefix('doctor')->group(function () {
        Route::get('/profile', [DoctorController::class, 'profile']);
        Route::put('/profile', [DoctorController::class, 'updateProfile']);
        Route::get('/stats', [DoctorController::class, 'stats']);
        Route::get('/appointments', [DoctorController::class, 'appointments']);
        Route::patch('/appointments/{id}/status', [DoctorController::class, 'updateAppointmentStatus']);
        Route::get('/patients', [DoctorController::class, 'patients']);
    });

    // ─── Admin Routes ───────────────────────────────────────────────────────
    Route::middleware([\App\Http\Middleware\IsAdmin::class])->prefix('admin')->group(function () {
        Route::get('/dashboard', [DashboardController::class, 'index']);
        Route::apiResource('banners', BannerController::class);
        Route::apiResource('articles', ArticleController::class);
        Route::apiResource('notifications', NotificationController::class);
        Route::get('/appointments', [AppointmentController::class, 'index']);

        // Doctors
        Route::get('/doctors', [\App\Http\Controllers\Api\Admin\AdminDoctorController::class, 'index']);
        Route::patch('/doctors/{id}/approve', [\App\Http\Controllers\Api\Admin\AdminDoctorController::class, 'approve']);
        Route::patch('/doctors/{id}/reject', [\App\Http\Controllers\Api\Admin\AdminDoctorController::class, 'reject']);
        Route::delete('/doctors/{id}', [\App\Http\Controllers\Api\Admin\AdminDoctorController::class, 'destroy']);

        // Nurses
        Route::get('/nurses', [\App\Http\Controllers\Api\Admin\AdminNurseController::class, 'index']);
        Route::patch('/nurses/{id}/approve', [\App\Http\Controllers\Api\Admin\AdminNurseController::class, 'approve']);
        Route::patch('/nurses/{id}/reject', [\App\Http\Controllers\Api\Admin\AdminNurseController::class, 'reject']);
        Route::delete('/nurses/{id}', [\App\Http\Controllers\Api\Admin\AdminNurseController::class, 'destroy']);

        // Users
        Route::get('/users', [\App\Http\Controllers\Api\Admin\AdminUserController::class, 'index']);
        Route::patch('/users/{id}/block', [\App\Http\Controllers\Api\Admin\AdminUserController::class, 'block']);
        Route::patch('/users/{id}/unblock', [\App\Http\Controllers\Api\Admin\AdminUserController::class, 'unblock']);
    });
});
