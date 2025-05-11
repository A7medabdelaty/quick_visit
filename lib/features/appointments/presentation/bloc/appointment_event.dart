// ... existing code ...
import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';

// Events
abstract class AppointmentEvent {}

class FetchActiveAppointments extends AppointmentEvent {}

class FetchPreviousAppointments extends AppointmentEvent {}

class CreateAppointment extends AppointmentEvent {
  final Appointment appointment;
  CreateAppointment(this.appointment);
}

class CancelAppointment extends AppointmentEvent {
  final String appointmentId;
  CancelAppointment(this.appointmentId);
}

class RescheduleAppointment extends AppointmentEvent {
  final String appointmentId;
  final Appointment newDateTime;

  RescheduleAppointment(this.appointmentId, this.newDateTime);
}

class StoreAppointmentUnderUser extends AppointmentEvent {
  final Appointment appointment;
  final String userId;

  StoreAppointmentUnderUser(this.appointment, this.userId);
}
