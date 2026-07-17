<?php

use Illuminate\Support\Facades\Route;

Route::get('/{locale?}', function ($locale = 'ckb') {
    if (!in_array($locale, ['en', 'ar', 'ckb'])) {
        abort(404);
    }
    app()->setLocale($locale);
    return view('welcome', ['locale' => $locale]);
});

use App\Http\Controllers\Web\DoctorAuthController;
use App\Http\Controllers\Web\DoctorDashboardController;
use App\Http\Controllers\Web\DoctorAppointmentController;
use App\Http\Controllers\Web\DoctorPatientController;
use App\Http\Controllers\Web\DoctorEarningsController;
use App\Http\Controllers\Web\DoctorProfileController;
use App\Http\Middleware\IsDoctor;

Route::prefix('doctor')->group(function () {
    Route::get('/login', [DoctorAuthController::class, 'showLogin'])->name('doctor.login');
    Route::post('/login', [DoctorAuthController::class, 'login']);
    
    Route::get('/register', [DoctorAuthController::class, 'showRegister'])->name('doctor.register');
    Route::post('/register', [DoctorAuthController::class, 'register']);
    
    Route::middleware(['auth', IsDoctor::class])->group(function () {
        Route::get('/dashboard', [DoctorDashboardController::class, 'index'])->name('doctor.dashboard');
        
        // Appointments
        Route::get('/appointments', [DoctorAppointmentController::class, 'index'])->name('doctor.appointments.index');
        Route::patch('/appointments/{appointment}/status', [DoctorAppointmentController::class, 'updateStatus'])->name('doctor.appointments.update_status');
        
        // Patients
        Route::get('/patients', [DoctorPatientController::class, 'index'])->name('doctor.patients.index');
        
        // Earnings
        Route::get('/earnings', [DoctorEarningsController::class, 'index'])->name('doctor.earnings.index');
        
        // Profile
        Route::get('/profile', [DoctorProfileController::class, 'index'])->name('doctor.profile.index');
        Route::put('/profile', [DoctorProfileController::class, 'update'])->name('doctor.profile.update');
        
        Route::post('/logout', [DoctorAuthController::class, 'logout'])->name('doctor.logout');
    });
});

use App\Http\Controllers\Web\NurseAuthController;
use App\Http\Controllers\Web\NurseDashboardController;
use App\Http\Controllers\Web\NurseAppointmentController;
use App\Http\Controllers\Web\NursePatientController;
use App\Http\Controllers\Web\NurseEarningsController;
use App\Http\Controllers\Web\NurseProfileController;
use App\Http\Middleware\IsNurse;

Route::prefix('nurse')->group(function () {
    Route::get('/login', [NurseAuthController::class, 'showLogin'])->name('nurse.login');
    Route::post('/login', [NurseAuthController::class, 'login']);
    
    Route::get('/register', [NurseAuthController::class, 'showRegister'])->name('nurse.register');
    Route::post('/register', [NurseAuthController::class, 'register']);
    
    Route::middleware(['auth', IsNurse::class])->group(function () {
        Route::get('/dashboard', [NurseDashboardController::class, 'index'])->name('nurse.dashboard');
        
        // Appointments
        Route::get('/appointments', [NurseAppointmentController::class, 'index'])->name('nurse.appointments.index');
        Route::patch('/appointments/{appointment}/status', [NurseAppointmentController::class, 'updateStatus'])->name('nurse.appointments.update_status');
        
        // Patients
        Route::get('/patients', [NursePatientController::class, 'index'])->name('nurse.patients.index');
        
        // Earnings
        Route::get('/earnings', [NurseEarningsController::class, 'index'])->name('nurse.earnings.index');
        
        // Profile
        Route::get('/profile', [NurseProfileController::class, 'index'])->name('nurse.profile.index');
        Route::put('/profile', [NurseProfileController::class, 'update'])->name('nurse.profile.update');
        
        Route::post('/logout', [NurseAuthController::class, 'logout'])->name('nurse.logout');
    });
});

