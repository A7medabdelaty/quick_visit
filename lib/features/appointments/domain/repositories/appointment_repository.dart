import 'package:service_reservation_system/features/appointments/domain/models/appointment_status.dart';

import '../models/appointment.dart';

abstract class AppointmentRepository {
  Future<void> createAppointment(Appointment appointment);
  Future<List<Appointment>> getActiveAppointments(String userId);
  Future<List<Appointment>> getPreviousAppointments(String userId);
  Future<void> cancelAppointment(String appointmentId);
  Future<void> rescheduleAppointment(
    String appointmentId,
    String newDate,
    String newTime,
  );

  Future<void> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  );
}
