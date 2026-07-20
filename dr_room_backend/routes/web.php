<?php

use Illuminate\Support\Facades\Route;

// Locale route moved to bottom

use App\Http\Controllers\Web\StaffAuthController;
use App\Http\Controllers\Web\DoctorDashboardController;
use App\Http\Controllers\Web\DoctorAppointmentController;
use App\Http\Controllers\Web\DoctorPatientController;
use App\Http\Controllers\Web\DoctorEarningsController;
use App\Http\Controllers\Web\DoctorProfileController;
use App\Http\Middleware\IsDoctor;

use App\Http\Controllers\Web\NurseDashboardController;
use App\Http\Controllers\Web\NurseAppointmentController;
use App\Http\Controllers\Web\NursePatientController;
use App\Http\Controllers\Web\NurseEarningsController;
use App\Http\Controllers\Web\NurseProfileController;
use App\Http\Middleware\IsNurse;

// Unified Staff Auth Routes
Route::prefix('staff')->group(function () {
    Route::get('/', function () {
        return view('auth.landing');
    })->name('staff.landing');

    Route::get('/login', [StaffAuthController::class, 'showLogin'])->name('staff.login');
    Route::post('/login', [StaffAuthController::class, 'login']);
    
    Route::get('/register', [StaffAuthController::class, 'showRegister'])->name('staff.register');
    Route::post('/register', [StaffAuthController::class, 'register']);
    
    Route::post('/logout', [StaffAuthController::class, 'logout'])->name('staff.logout')->middleware('auth');
});

// Doctor Dashboard Routes
Route::prefix('doctor')->middleware(['auth', IsDoctor::class])->group(function () {
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
});

// Nurse Dashboard Routes
Route::prefix('nurse')->middleware(['auth', IsNurse::class])->group(function () {
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
});

Route::get('/{locale?}', function ($locale = 'ckb') {
    if (!in_array($locale, ['en', 'ar', 'ckb'])) {
        abort(404);
    }
    app()->setLocale($locale);
    return view('welcome', ['locale' => $locale]);
});

