import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/appointment_model.dart';
import '../utils/api_client.dart';

class AppointmentService {
  /// Fetch all doctors
  Future<List<Doctor>> getDoctors({
    String? search,
    String? speciality,
    double? minRating,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (speciality != null) 'speciality': speciality,
        if (minRating != null) 'rating': minRating,
      };

      final query = Uri(queryParameters: queryParams).query;
      final endpoint = '/doctors?$query';

      final response = await ApiClient.get(endpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final doctors = (data['data'] as List)
            .map((d) => Doctor.fromJson(d))
            .toList();
        return doctors;
      } else {
        throw Exception('Failed to fetch doctors: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    }
  }

  /// Get doctor details
  Future<Doctor> getDoctorDetails(String doctorId) async {
    try {
      final response = await ApiClient.get('/doctors/$doctorId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Doctor.fromJson(data['data']);
      } else {
        throw Exception('Failed to fetch doctor details');
      }
    } catch (e) {
      throw Exception('Error fetching doctor details: $e');
    }
  }

  /// Get available slots for doctor
  Future<List<DoctorSlot>> getDoctorSlots(
    String doctorId, {
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (fromDate != null) 'from_date': fromDate.toIso8601String(),
        if (toDate != null) 'to_date': toDate.toIso8601String(),
      };

      final query = Uri(queryParameters: queryParams).query;
      final endpoint = '/doctors/$doctorId/availability?$query';

      final response = await ApiClient.get(endpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final slots = (data['data'] as List)
            .map((s) => DoctorSlot.fromJson(s))
            .toList();
        return slots;
      } else {
        throw Exception('Failed to fetch slots');
      }
    } catch (e) {
      throw Exception('Error fetching slots: $e');
    }
  }

  /// Book appointment
  Future<Appointment> bookAppointment({
    required String doctorId,
    required DateTime slotDate,
    required String slotTime,
    String? reason,
    String? notes,
  }) async {
    try {
      final response = await ApiClient.post(
        '/appointments',
        body: {
          'doctor_id': doctorId,
          'slot_date': slotDate.toIso8601String(),
          'slot_time': slotTime,
          'reason': reason,
          'notes': notes,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final appointment = Appointment.fromJson(data['data']);
        await _cacheAppointment(appointment);
        return appointment;
      } else {
        throw Exception('Failed to book appointment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error booking appointment: $e');
    }
  }

  /// Get user appointments
  Future<List<Appointment>> getAppointments({
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (status != null) 'status': status,
      };

      final query = Uri(queryParameters: queryParams).query;
      final endpoint = '/appointments?$query';

      final response = await ApiClient.get(endpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final appointments = (data['data'] as List)
            .map((a) => Appointment.fromJson(a))
            .toList();
        return appointments;
      } else {
        throw Exception('Failed to fetch appointments');
      }
    } catch (e) {
      throw Exception('Error fetching appointments: $e');
    }
  }

  /// Get single appointment
  Future<Appointment> getAppointment(String appointmentId) async {
    try {
      final response = await ApiClient.get('/appointments/$appointmentId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Appointment.fromJson(data['data']);
      } else {
        throw Exception('Failed to fetch appointment');
      }
    } catch (e) {
      throw Exception('Error fetching appointment: $e');
    }
  }

  /// Cancel appointment
  Future<bool> cancelAppointment(
    String appointmentId, {
    required String reason,
    bool requestRefund = true,
  }) async {
    try {
      final response = await ApiClient.post(
        '/appointments/$appointmentId/cancel',
        body: {
          'reason': reason,
          'request_refund': requestRefund,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to cancel appointment');
      }
    } catch (e) {
      throw Exception('Error canceling appointment: $e');
    }
  }

  /// Reschedule appointment
  Future<Appointment> rescheduleAppointment(
    String appointmentId, {
    required DateTime newSlotDate,
    required String newSlotTime,
  }) async {
    try {
      final response = await ApiClient.put(
        '/appointments/$appointmentId',
        body: {
          'slot_date': newSlotDate.toIso8601String(),
          'slot_time': newSlotTime,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Appointment.fromJson(data['data']);
      } else {
        throw Exception('Failed to reschedule appointment');
      }
    } catch (e) {
      throw Exception('Error rescheduling appointment: $e');
    }
  }

  /// Get doctor reviews
  Future<List<DoctorReview>> getDoctorReviews(String doctorId) async {
    try {
      final response = await ApiClient.get('/doctors/$doctorId/reviews');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reviews = (data['data'] as List)
            .map((r) => DoctorReview.fromJson(r))
            .toList();
        return reviews;
      } else {
        throw Exception('Failed to fetch reviews');
      }
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }

  // Local caching
  Future<void> _cacheAppointment(Appointment appointment) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'appointment_${appointment.id}';
    await prefs.setString(key, jsonEncode(appointment.toJson()));
  }

  Future<Appointment?> getCachedAppointment(String appointmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'appointment_$appointmentId';
    final data = prefs.getString(key);
    if (data != null) {
      return Appointment.fromJson(jsonDecode(data));
    }
    return null;
  }
}
