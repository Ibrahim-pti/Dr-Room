import 'package:flutter_test/flutter_test.dart';
import 'package:dr_room/core/models/appointment_model.dart';

void main() {
  group('Appointment.fromJson', () {
    Map<String, dynamic> json({
      String status = 'confirmed',
      String? slotDate,
    }) =>
        {
          'id': 'apt_1',
          'doctor_id': 'doc_1',
          'doctor_name': 'Dr. Ahmed',
          'doctor_image': '',
          'speciality': 'Cardiology',
          'slot_date':
              slotDate ?? DateTime.now().add(const Duration(days: 3)).toIso8601String(),
          'slot_time': '10:00',
          'status': status,
          'amount': 50,
          'created_at': DateTime.now().toIso8601String(),
        };

    test('parses the documented status strings', () {
      expect(Appointment.fromJson(json(status: 'confirmed')).status,
          AppointmentStatus.confirmed);
      expect(Appointment.fromJson(json(status: 'completed')).status,
          AppointmentStatus.completed);
      expect(Appointment.fromJson(json(status: 'canceled')).status,
          AppointmentStatus.canceled);
    });

    test('falls back to pending for an unknown status', () {
      expect(Appointment.fromJson(json(status: 'wat')).status,
          AppointmentStatus.pending);
    });

    test('reads an integer amount as a double', () {
      expect(Appointment.fromJson(json()).amount, 50.0);
    });

    test('a confirmed future appointment can be cancelled and rescheduled', () {
      final appointment = Appointment.fromJson(json());
      expect(appointment.isUpcoming, isTrue);
      expect(appointment.canCancel, isTrue);
      expect(appointment.canReschedule, isTrue);
    });

    test('a past appointment cannot be cancelled', () {
      final appointment = Appointment.fromJson(json(
        slotDate: DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      ));
      expect(appointment.isUpcoming, isFalse);
      expect(appointment.canCancel, isFalse);
    });

    test('a cancelled future appointment cannot be cancelled again', () {
      final appointment = Appointment.fromJson(json(status: 'canceled'));
      expect(appointment.canCancel, isFalse);
    });

    test('survives a response missing every optional field', () {
      final appointment = Appointment.fromJson({});
      expect(appointment.id, '');
      expect(appointment.amount, 0.0);
      expect(appointment.status, AppointmentStatus.pending);
      expect(appointment.transactionId, isNull);
    });

    test('round-trips through toJson', () {
      final original = Appointment.fromJson(json());
      final restored = Appointment.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.status, original.status);
      expect(restored.amount, original.amount);
      expect(restored.slotTime, original.slotTime);
    });
  });

  group('Doctor.fromJson', () {
    test('reads the snake_case fields the API returns', () {
      final doctor = Doctor.fromJson({
        'id': 'doc_1',
        'name': 'Dr. Ahmed',
        'speciality': 'Cardiology',
        'qualification': 'MBBS, MD',
        'years_experience': 10,
        'rating': 4.8,
        'review_count': 150,
        'profile_image': 'https://example.com/a.png',
        'bio': 'Bio',
        'consultation_fee': 50,
        'clinic_id': 'c_1',
        'clinic_name': 'Modern Clinic',
        'languages': ['en', 'ckb'],
        'accepts_insurance': true,
      });

      expect(doctor.yearsExperience, 10);
      expect(doctor.reviewCount, 150);
      expect(doctor.consultationFee, 50.0);
      expect(doctor.languages, ['en', 'ckb']);
      expect(doctor.acceptsInsurance, isTrue);
    });

    test('defaults languages to an empty list when absent', () {
      expect(Doctor.fromJson({}).languages, isEmpty);
    });
  });
}
