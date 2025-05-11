import 'package:service_reservation_system/features/doctors/domain/models/doctor.dart';

abstract class DoctorsState {}

class DoctorsInitial extends DoctorsState {}

class DoctorsLoading extends DoctorsState {}

class DoctorsLoaded extends DoctorsState {
  final List<Doctor> doctors;
  DoctorsLoaded(this.doctors);
}

class DoctorsError extends DoctorsState {
  final String message;
  DoctorsError(this.message);
}
