import '../../domain/models/doctor.dart';

abstract class SearchDoctorsState {}

class SearchDoctorsInitial extends SearchDoctorsState {}

class SearchDoctorsLoading extends SearchDoctorsState {}

class SearchDoctorsLoaded extends SearchDoctorsState {
  final List<Doctor> doctors;
  final String query;

  SearchDoctorsLoaded(this.doctors, this.query);
}

class SearchDoctorsError extends SearchDoctorsState {
  final String message;

  SearchDoctorsError(this.message);
}
