import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/features/doctors/domain/repositories/doctor_repository.dart';

import '../../domain/models/doctor.dart';

// Events
abstract class TopDoctorsEvent {}

class FetchTopDoctors extends TopDoctorsEvent {}

// States
abstract class TopDoctorsState {}

class TopDoctorsInitial extends TopDoctorsState {}

class TopDoctorsLoading extends TopDoctorsState {}

class TopDoctorsLoaded extends TopDoctorsState {
  final List<Doctor> doctors;
  TopDoctorsLoaded(this.doctors);
}

class TopDoctorsError extends TopDoctorsState {
  final String message;
  TopDoctorsError(this.message);
}

// BLoC
class TopDoctorsBloc extends Bloc<TopDoctorsEvent, TopDoctorsState> {
  final DoctorRepository repository;

  TopDoctorsBloc({required this.repository}) : super(TopDoctorsInitial()) {
    on<FetchTopDoctors>((event, emit) async {
      emit(TopDoctorsLoading());
      final result = await repository.getTopDoctors();
      result.fold(
        (failure) => emit(TopDoctorsError(failure.message)),
        (doctors) => emit(TopDoctorsLoaded(doctors)),
      );
    });
  }
}
