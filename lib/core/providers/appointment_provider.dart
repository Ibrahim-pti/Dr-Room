import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentService _appointmentService = AppointmentService();

  List<Doctor> _doctors = [];
  List<Appointment> _appointments = [];
  List<DoctorSlot> _availableSlots = [];
  List<DoctorReview> _doctorReviews = [];

  Doctor? _selectedDoctor;
  DoctorSlot? _selectedSlot;
  Appointment? _currentAppointment;

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Doctor> get doctors => _doctors;
  List<Appointment> get appointments => _appointments;
  List<DoctorSlot> get availableSlots => _availableSlots;
  List<DoctorReview> get doctorReviews => _doctorReviews;
  Doctor? get selectedDoctor => _selectedDoctor;
  DoctorSlot? get selectedSlot => _selectedSlot;
  Appointment? get currentAppointment => _currentAppointment;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get appointmentFee => _selectedDoctor?.consultationFee ?? 0;

  /// Fetch doctors
  Future<bool> fetchDoctors({
    String? search,
    String? speciality,
    double? minRating,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _doctors = await _appointmentService.getDoctors(
        search: search,
        speciality: speciality,
        minRating: minRating,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch doctor details
  Future<bool> fetchDoctorDetails(String doctorId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final doctor = await _appointmentService.getDoctorDetails(doctorId);
      _selectedDoctor = doctor;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch available slots
  Future<bool> fetchAvailableSlots(
    String doctorId, {
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _availableSlots = await _appointmentService.getDoctorSlots(
        doctorId,
        fromDate: fromDate,
        toDate: toDate,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch doctor reviews
  Future<bool> fetchDoctorReviews(String doctorId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _doctorReviews = await _appointmentService.getDoctorReviews(doctorId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Select doctor
  void selectDoctor(Doctor doctor) {
    _selectedDoctor = doctor;
    _selectedSlot = null;
    _error = null;
    notifyListeners();
  }

  /// Select slot
  void selectSlot(DoctorSlot slot) {
    _selectedSlot = slot;
    _error = null;
    notifyListeners();
  }

  /// Book appointment
  Future<bool> bookAppointment({
    required String reason,
    String? notes,
  }) async {
    if (_selectedDoctor == null || _selectedSlot == null) {
      _error = 'Please select doctor and time slot';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentAppointment = await _appointmentService.bookAppointment(
        doctorId: _selectedDoctor!.id,
        slotDate: _selectedSlot!.date,
        slotTime: _selectedSlot!.time,
        reason: reason,
        notes: notes,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch appointments
  Future<bool> fetchAppointments({String? status}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _appointments = await _appointmentService.getAppointments(status: status);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cancel appointment
  Future<bool> cancelAppointment(
    String appointmentId, {
    required String reason,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _appointmentService.cancelAppointment(
        appointmentId,
        reason: reason,
        requestRefund: true,
      );

      _appointments.removeWhere((a) => a.id == appointmentId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Reschedule appointment
  Future<bool> rescheduleAppointment(
    String appointmentId, {
    required DateTime newDate,
    required String newTime,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updated = await _appointmentService.rescheduleAppointment(
        appointmentId,
        newSlotDate: newDate,
        newSlotTime: newTime,
      );

      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = updated;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear selection
  void clearSelection() {
    _selectedDoctor = null;
    _selectedSlot = null;
    _currentAppointment = null;
    _error = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
