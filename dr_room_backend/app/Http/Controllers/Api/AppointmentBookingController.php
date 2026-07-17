<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Models\Doctor;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

/**
 * Appointment booking API for patients (mobile app users).
 */
class AppointmentBookingController extends Controller
{
    /**
     * POST /api/appointments
     * Book an appointment with a doctor.
     */
    public function store(Request $request)
    {
        $request->validate([
            'doctor_id'        => 'required|exists:doctors,id',
            'appointment_date' => 'required|date|after:now',
            'type'             => 'sometimes|in:in_person,online',
            'notes'            => 'nullable|string|max:500',
        ]);

        $doctor = Doctor::findOrFail($request->doctor_id);

        $appointment = Appointment::create([
            'doctor_id'        => $request->doctor_id,
            'patient_id'       => Auth::id(),
            'appointment_date' => $request->appointment_date,
            'type'             => $request->type ?? 'in_person',
            'notes'            => $request->notes,
            'fee'              => $doctor->consultation_fee,
            'status'           => 'pending',
        ]);

        return response()->json([
            'message'     => 'Appointment booked successfully.',
            'appointment' => $appointment->load('doctor.user:id,name', 'patient:id,name'),
        ], 201);
    }

    /**
     * GET /api/appointments
     * Get the authenticated patient's appointments.
     */
    public function index(Request $request)
    {
        $query = Appointment::where('patient_id', Auth::id())
            ->with('doctor.user:id,name', 'doctor:id,user_id,specialty,image_path,rating');

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        $appointments = $query->orderBy('appointment_date', 'desc')->get();

        return response()->json([
            'data'  => $appointments,
            'total' => $appointments->count(),
        ]);
    }

    /**
     * DELETE /api/appointments/{id}
     * Cancel an appointment (patient cancels their own).
     */
    public function destroy($id)
    {
        $appointment = Appointment::where('patient_id', Auth::id())->findOrFail($id);

        if ($appointment->status === 'completed') {
            return response()->json(['message' => 'Cannot cancel a completed appointment.'], 422);
        }

        $appointment->update(['status' => 'cancelled']);

        return response()->json(['message' => 'Appointment cancelled successfully.']);
    }
}
