import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Doctor {
  final String id;
  final String name;
  final String speciality;
  final String qualification;
  final int yearsExperience;
  final double rating;
  final int reviewCount;
  final String profileImage;
  final String bio;
  final double consultationFee;
  final String clinicId;
  final String clinicName;
  final List<String> languages;
  final bool acceptsInsurance;

  Doctor({
    required this.id,
    required this.name,
    required this.speciality,
    required this.qualification,
    required this.yearsExperience,
    required this.rating,
    required this.reviewCount,
    required this.profileImage,
    required this.bio,
    required this.consultationFee,
    required this.clinicId,
    required this.clinicName,
    required this.languages,
    required this.acceptsInsurance,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      speciality: json['speciality'] ?? '',
      qualification: json['qualification'] ?? '',
      yearsExperience: json['years_experience'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      profileImage: json['profile_image'] ?? '',
      bio: json['bio'] ?? '',
      consultationFee: (json['consultation_fee'] ?? 0).toDouble(),
      clinicId: json['clinic_id'] ?? '',
      clinicName: json['clinic_name'] ?? '',
      languages: List<String>.from(json['languages'] ?? []),
      acceptsInsurance: json['accepts_insurance'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'speciality': speciality,
    'qualification': qualification,
    'years_experience': yearsExperience,
    'rating': rating,
    'review_count': reviewCount,
    'profile_image': profileImage,
    'bio': bio,
    'consultation_fee': consultationFee,
    'clinic_id': clinicId,
    'clinic_name': clinicName,
    'languages': languages,
    'accepts_insurance': acceptsInsurance,
  };
}

class DoctorSlot {
  final String id;
  final String doctorId;
  final DateTime date;
  final String time;
  final bool isAvailable;
  final int maxPatients;
  final int bookedPatients;

  DoctorSlot({
    required this.id,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.isAvailable,
    required this.maxPatients,
    required this.bookedPatients,
  });

  factory DoctorSlot.fromJson(Map<String, dynamic> json) {
    return DoctorSlot(
      id: json['id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      time: json['time'] ?? '',
      isAvailable: json['is_available'] ?? false,
      maxPatients: json['max_patients'] ?? 1,
      bookedPatients: json['booked_patients'] ?? 0,
    );
  }

  String get displayTime => time;
  String get formattedDate => DateFormat('EEEE, MMMM d').format(date);
}

class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorImage;
  final String speciality;
  final DateTime slotDate;
  final String slotTime;
  final AppointmentStatus status;
  final double amount;
  final String? transactionId;
  final String? notes;
  final String? reason;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? cancellationReason;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorImage,
    required this.speciality,
    required this.slotDate,
    required this.slotTime,
    required this.status,
    required this.amount,
    this.transactionId,
    this.notes,
    this.reason,
    required this.createdAt,
    this.completedAt,
    this.cancellationReason,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      doctorImage: json['doctor_image'] ?? '',
      speciality: json['speciality'] ?? '',
      slotDate: DateTime.parse(json['slot_date'] ?? DateTime.now().toIso8601String()),
      slotTime: json['slot_time'] ?? '',
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString() == 'AppointmentStatus.${json['status']}',
        orElse: () => AppointmentStatus.pending,
      ),
      amount: (json['amount'] ?? 0).toDouble(),
      transactionId: json['transaction_id'],
      notes: json['notes'],
      reason: json['reason'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      cancellationReason: json['cancellation_reason'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctor_id': doctorId,
    'doctor_name': doctorName,
    'doctor_image': doctorImage,
    'speciality': speciality,
    'slot_date': slotDate.toIso8601String(),
    'slot_time': slotTime,
    'status': status.toString().split('.').last,
    'amount': amount,
    'transaction_id': transactionId,
    'notes': notes,
    'reason': reason,
    'created_at': createdAt.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
    'cancellation_reason': cancellationReason,
  };

  String get formattedDate => DateFormat('MMM dd, yyyy').format(slotDate);
  String get formattedDateTime => '$formattedDate at $slotTime';
  bool get isUpcoming => slotDate.isAfter(DateTime.now());
  bool get canCancel => status == AppointmentStatus.confirmed && isUpcoming;
  bool get canReschedule => status == AppointmentStatus.confirmed && isUpcoming;
}

enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  canceled,
  noShow,
}

extension AppointmentStatusExt on AppointmentStatus {
  String get displayName {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.canceled:
        return 'Canceled';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }

  String get kurdiName {
    switch (this) {
      case AppointmentStatus.pending:
        return 'چاوەڕێدان';
      case AppointmentStatus.confirmed:
        return 'پەسند کراو';
      case AppointmentStatus.completed:
        return 'تەواو بوو';
      case AppointmentStatus.canceled:
        return 'لەبیر کرا';
      case AppointmentStatus.noShow:
        return 'تێنەگەیشت';
    }
  }

  Color getColor() {
    switch (this) {
      case AppointmentStatus.pending:
        return const Color(0xFFF59E0B);
      case AppointmentStatus.confirmed:
        return const Color(0xFF2E86DE);
      case AppointmentStatus.completed:
        return const Color(0xFF27AE60);
      case AppointmentStatus.canceled:
        return const Color(0xFFEF4444);
      case AppointmentStatus.noShow:
        return const Color(0xFF6E7191);
    }
  }
}

class DoctorReview {
  final String id;
  final String doctorId;
  final String userName;
  final String userImage;
  final double rating;
  final String review;
  final DateTime createdAt;

  DoctorReview({
    required this.id,
    required this.doctorId,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory DoctorReview.fromJson(Map<String, dynamic> json) {
    return DoctorReview(
      id: json['id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      review: json['review'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
