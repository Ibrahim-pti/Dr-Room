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
    
    Route::get('/waiting', [StaffAuthController::class, 'waiting'])->name('staff.waiting')->middleware('auth');
    Route::get('/status', [StaffAuthController::class, 'status'])->name('staff.status')->middleware('auth');
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
    
    // New Feature Placeholders (Doctor)
    $doctorPlaceholder = function ($title) {
        return view('shared.placeholder', ['layout' => 'doctor.layouts.app', 'title' => $title]);
    };
    
    // Patient sub-routes
    Route::get('/patients/history', fn() => $doctorPlaceholder('مێژووی پزیشکی'))->name('doctor.patients.history');
    Route::get('/patients/allergies', fn() => $doctorPlaceholder('هەستیارییەکان'))->name('doctor.patients.allergies');
    Route::get('/patients/files', fn() => $doctorPlaceholder('فایلە پزیشکییەکان'))->name('doctor.patients.files');
    
    // Appointment sub-routes
    Route::get('/appointments/history', fn() => $doctorPlaceholder('مێژووی چاوپێکەوتنەکان'))->name('doctor.appointments.history');
    
    // Consultations
    Route::get('/consultation', fn() => $doctorPlaceholder('ڕاوێژکاری'))->name('doctor.consultation.index');
    Route::get('/consultation/video', fn() => $doctorPlaceholder('ڕاوێژکاری ڤیدیۆیی'))->name('doctor.consultation.video');
    Route::get('/consultation/voice', fn() => $doctorPlaceholder('ڕاوێژکاری دەنگی'))->name('doctor.consultation.voice');
    Route::get('/consultation/chat', fn() => $doctorPlaceholder('چاتی ڕاستەوخۆ'))->name('doctor.consultation.chat');
    
    // Diagnosis
    Route::get('/diagnosis', fn() => $doctorPlaceholder('دەستنیشانکردن'))->name('doctor.diagnosis.index');
    Route::get('/diagnosis/create', fn() => $doctorPlaceholder('زیادکردنی دەستنیشانکردن'))->name('doctor.diagnosis.create');
    Route::get('/diagnosis/plan', fn() => $doctorPlaceholder('پلانی چارەسەر'))->name('doctor.diagnosis.plan');
    
    // Laboratory
    Route::get('/laboratory', fn() => $doctorPlaceholder('تاقیگە'))->name('doctor.laboratory.index');
    Route::get('/laboratory/request', fn() => $doctorPlaceholder('داواکردنی پشکنین'))->name('doctor.laboratory.request');
    Route::get('/laboratory/results', fn() => $doctorPlaceholder('ئەنجامەکانی پشکنین'))->name('doctor.laboratory.results');
    
    // Prescriptions
    Route::get('/prescriptions', fn() => $doctorPlaceholder('ڕەچەتەکان'))->name('doctor.prescriptions.index');
    Route::get('/prescriptions/create', fn() => $doctorPlaceholder('نووسینی ڕەچەتە'))->name('doctor.prescriptions.create');
    Route::get('/prescriptions/history', fn() => $doctorPlaceholder('مێژووی ڕەچەتەکان'))->name('doctor.prescriptions.history');
    
    // Messages
    Route::get('/messages', fn() => $doctorPlaceholder('نامەکان'))->name('doctor.messages.index');
    Route::get('/messages/patients', fn() => $doctorPlaceholder('نامەی نەخۆشەکان'))->name('doctor.messages.patients');
    Route::get('/messages/staff', fn() => $doctorPlaceholder('نامەی ستاف'))->name('doctor.messages.staff');
    
    // Notifications
    Route::get('/notifications', fn() => $doctorPlaceholder('ئاگادارکردنەوەکان'))->name('doctor.notifications.index');
    
    // Settings
    Route::get('/settings', fn() => $doctorPlaceholder('ڕێکخستنەکان'))->name('doctor.settings.index');
});

// Nurse Dashboard Routes
Route::prefix('nurse')->middleware(['auth', IsNurse::class])->group(function () {
    Route::get('/dashboard', [NurseDashboardController::class, 'index'])->name('nurse.dashboard');
    
    // Appointments
    Route::get('/appointments', [NurseAppointmentController::class, 'index'])->name('nurse.appointments.index');
    Route::patch('/appointments/{appointment}/status', [NurseAppointmentController::class, 'updateStatus'])->name('nurse.appointments.update_status');
    
    // Patients (Patient Care)
    Route::get('/patients', [NursePatientController::class, 'index'])->name('nurse.patients.index');
    
    // Earnings
    Route::get('/earnings', [NurseEarningsController::class, 'index'])->name('nurse.earnings.index');
    
    // Profile
    Route::get('/profile', [NurseProfileController::class, 'index'])->name('nurse.profile.index');
    Route::put('/profile', [NurseProfileController::class, 'update'])->name('nurse.profile.update');
    
    // New Feature Placeholders (Nurse)
    $nursePlaceholder = function ($title) {
        return view('shared.placeholder', ['layout' => 'nurse.layouts.app', 'title' => $title]);
    };
    
    // Patient Care sub-routes
    Route::get('/patients/symptoms', fn() => $nursePlaceholder('تۆمارکردنی نیشانەکان'))->name('nurse.patients.symptoms');
    Route::get('/patients/monitoring', fn() => $nursePlaceholder('چاودێریکردنی نەخۆش'))->name('nurse.patients.monitoring');
    Route::get('/patients/notes', fn() => $nursePlaceholder('تێبینی ڕۆژانە'))->name('nurse.patients.notes');
    Route::get('/patients/medication', fn() => $nursePlaceholder('پێدانی دەرمان'))->name('nurse.patients.medication');
    
    // Appointments sub-routes
    Route::get('/appointments/confirm', fn() => $nursePlaceholder('دڵنیابوونەوە لە کات'))->name('nurse.appointments.confirm');
    Route::get('/appointments/prepare', fn() => $nursePlaceholder('ئامادەکردنی نەخۆش'))->name('nurse.appointments.prepare');
    
    // Communication
    Route::get('/communication', fn() => $nursePlaceholder('پەیوەندی'))->name('nurse.communication.index');
    Route::get('/communication/doctor', fn() => $nursePlaceholder('چات لەگەڵ دکتۆر'))->name('nurse.communication.doctor');
    Route::get('/communication/patient', fn() => $nursePlaceholder('چات لەگەڵ نەخۆش'))->name('nurse.communication.patient');
    
    // Reports
    Route::get('/reports', fn() => $nursePlaceholder('ڕاپۆرتەکان'))->name('nurse.reports.index');
    Route::get('/reports/progress', fn() => $nursePlaceholder('بەرەوپێشچوونی نەخۆش'))->name('nurse.reports.progress');
    
    // Profile sub-routes
    Route::get('/profile/schedule', fn() => $nursePlaceholder('خشتەی کارکردن'))->name('nurse.profile.schedule');
});

// Lab Dashboard Routes
Route::prefix('lab')->middleware(['auth', \App\Http\Middleware\IsLab::class])->group(function () {
    Route::get('/dashboard', [\App\Http\Controllers\Web\LabDashboardController::class, 'index'])->name('lab.dashboard');
    
    // Patients
    Route::get('/patients', [\App\Http\Controllers\Web\LabPatientController::class, 'index'])->name('lab.patients.index');
    
    // Profile
    Route::get('/profile', [\App\Http\Controllers\Web\LabProfileController::class, 'index'])->name('lab.profile.index');
    Route::put('/profile', [\App\Http\Controllers\Web\LabProfileController::class, 'update'])->name('lab.profile.update');
    
    // New Feature Placeholders (Lab)
    $labPlaceholder = function ($title) {
        return view('shared.placeholder', ['layout' => 'lab.layouts.app', 'title' => $title]);
    };
    
    // Tests
    Route::get('/tests', fn() => $labPlaceholder('پشکنینەکان'))->name('lab.tests.index');
    Route::get('/tests/create', fn() => view('lab.tests.create'))->name('lab.tests.create');
    Route::get('/test-types/create', fn() => view('lab.test-types.create'))->name('lab.test-types.create');
    Route::get('/tests/blood', fn() => $labPlaceholder('پشکنینی خوێن'))->name('lab.tests.blood');
    Route::get('/tests/urine', fn() => $labPlaceholder('پشکنینی میز'))->name('lab.tests.urine');
    Route::get('/tests/hormone', fn() => $labPlaceholder('پشکنینی هۆرمۆن'))->name('lab.tests.hormone');
    Route::get('/tests/other', fn() => $labPlaceholder('پشکنینەکانی تر'))->name('lab.tests.other');
    
    // Management
    Route::get('/management/approve', fn() => $labPlaceholder('پەسەندکردنی پشکنین'))->name('lab.management.approve');
    Route::get('/management/complete', fn() => $labPlaceholder('تەواوکردنی پشکنین'))->name('lab.management.complete');
    
    // Results
    Route::get('/results', fn() => $labPlaceholder('ئەنجامەکان'))->name('lab.results.index');
    Route::get('/results/add', fn() => $labPlaceholder('زیادکردنی ئەنجام'))->name('lab.results.add');
    Route::get('/results/edit', fn() => $labPlaceholder('گۆڕانکاری لە ئەنجام'))->name('lab.results.edit');
    Route::get('/results/upload', fn() => $labPlaceholder('بەرزکردنەوەی PDF'))->name('lab.results.upload');
    
    // Reports
    Route::get('/reports', fn() => $labPlaceholder('ڕاپۆرتەکان'))->name('lab.reports.index');
    
    // Communication
    Route::get('/communication', fn() => $labPlaceholder('پەیوەندی'))->name('lab.communication.index');
    
    // Profile sub-routes
    Route::get('/profile/staff', fn() => $labPlaceholder('ستافی تاقیگە'))->name('lab.profile.staff');
});

Route::get('/{locale?}', function ($locale = 'ckb') {
    if (!in_array($locale, ['en', 'ar', 'ckb'])) {
        abort(404);
    }
    app()->setLocale($locale);
    return view('welcome', ['locale' => $locale]);
});

