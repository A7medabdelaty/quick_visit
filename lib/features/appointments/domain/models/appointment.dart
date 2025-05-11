import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment_status.dart';

class Appointment {
  final String id;
  final String doctorId;
  final String patientId;
  final String doctorName;
  final String patientName;
  final String specialty;
  final String selectedDate;
  final String selectedTime;
  final double consultationFee;
  final String location;
  final AppointmentStatus status;
  final DateTime createdAt;

  const Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
    required this.patientName,
    required this.specialty,
    required this.selectedDate,
    required this.selectedTime,
    required this.consultationFee,
    required this.location,
    required this.status,
    required this.createdAt,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] ?? '',
      doctorId: map['doctorId'] ?? '',
      patientId: map['patientId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      patientName: map['patientName'] ?? '',
      specialty: map['specialty'] ?? '',
      selectedDate: map['selectedDate'] ?? '',
      selectedTime: map['selectedTime'] ?? '',
      consultationFee: (map['consultationFee'] ?? 0.0).toDouble(),
      location: map['location'] ?? '',
      status:
          map['status'] is String
              ? AppointmentStatus.fromString(map['status'])
              : AppointmentStatus.pending,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'doctorName': doctorName,
      'patientName': patientName,
      'specialty': specialty,
      'selectedDate': selectedDate,
      'selectedTime': selectedTime,
      'consultationFee': consultationFee,
      'location': location,
      'status': status.name,
      'createdAt': createdAt,
    };
  }

  Appointment copyWith({
    String? id,
    String? doctorId,
    String? patientId,
    String? doctorName,
    String? patientName,
    String? specialty,
    String? selectedDate,
    String? selectedTime,
    double? consultationFee,
    String? location,
    AppointmentStatus? status,
    DateTime? createdAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      doctorName: doctorName ?? this.doctorName,
      patientName: patientName ?? this.patientName,
      specialty: specialty ?? this.specialty,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      consultationFee: consultationFee ?? this.consultationFee,
      location: location ?? this.location,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
