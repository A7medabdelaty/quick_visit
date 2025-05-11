import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';

abstract class BookingRepository {
  Future<List<DateTime>> getAvailableSlots(String doctorId, DateTime date);
  Future<void> bookAppointment(String doctorId, DateTime dateTime);
  Future<List<Appointment>> getAppointments(bool isActive);
}
