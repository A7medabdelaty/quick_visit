import '../../domain/models/doctor.dart';

abstract class SpecialtyDoctorsState {}

class SpecialtyDoctorsInitial extends SpecialtyDoctorsState {}

class SpecialtyDoctorsLoading extends SpecialtyDoctorsState {}

class SpecialtyDoctorsLoaded extends SpecialtyDoctorsState {
  final List<Doctor> doctors;

  SpecialtyDoctorsLoaded(this.doctors);
}

class SpecialtyDoctorsError extends SpecialtyDoctorsState {
  final String message;

  SpecialtyDoctorsError(this.message);
}
