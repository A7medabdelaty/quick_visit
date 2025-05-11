import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentSuccess extends AppointmentState {
  final List<Appointment> appointments;
  AppointmentSuccess(this.appointments);
}

class AppointmentError extends AppointmentState {
  final String message;
  AppointmentError(this.message);
}
