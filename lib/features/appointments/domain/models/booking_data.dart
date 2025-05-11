import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';
import 'package:service_reservation_system/features/appointments/domain/models/patient_details.dart';

class BookingData {
  final String doctorName;
  final String specialty;
  final String location;
  final String bookingId;
  final String selectedDate;
  final String selectedTime;
  final String doctorId;
  final double consultationFee;
  final Map<String, dynamic> patientDetails;

  const BookingData({
    required this.doctorName,
    required this.specialty,
    required this.location,
    required this.bookingId,
    required this.selectedDate,
    required this.selectedTime,
    required this.doctorId,
    required this.consultationFee,
    required this.patientDetails,
  });

  // Factory constructor to create from Appointment
  factory BookingData.fromAppointment(
    Appointment appointment,
    PatientDetails patient,
    double consultationFee,
  ) {
    return BookingData(
      doctorName: appointment.doctorName,
      specialty: appointment.specialty,
      location: appointment.location,
      bookingId: appointment.id,
      selectedDate: appointment.selectedDate,
      selectedTime: appointment.selectedTime,
      doctorId: appointment.doctorId,
      consultationFee: consultationFee,
      patientDetails: patient.toMap(),
    );
  }
}
