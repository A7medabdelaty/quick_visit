import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/doctor_repository.dart';
import 'specialty_doctors_event.dart';
import 'specialty_doctors_state.dart';

class SpecialtyDoctorsBloc
    extends Bloc<SpecialtyDoctorsEvent, SpecialtyDoctorsState> {
  final DoctorRepository repository;

  SpecialtyDoctorsBloc({required this.repository})
    : super(SpecialtyDoctorsInitial()) {
    on<FetchSpecialtyDoctorsEvent>(_onFetchSpecialtyDoctors);
  }

  Future<void> _onFetchSpecialtyDoctors(
    FetchSpecialtyDoctorsEvent event,
    Emitter<SpecialtyDoctorsState> emit,
  ) async {
    emit(SpecialtyDoctorsLoading());
    final result = await repository.getDoctorsBySpecialty(event.specialty);
    result.fold(
      (failure) => emit(SpecialtyDoctorsError(failure.message)),
      (doctors) => emit(SpecialtyDoctorsLoaded(doctors)),
    );
  }
}
