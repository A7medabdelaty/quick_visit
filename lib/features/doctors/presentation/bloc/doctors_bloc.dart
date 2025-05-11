import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/doctor_repository.dart';
import 'doctors_event.dart';
import 'doctors_state.dart';

class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  final DoctorRepository _repository;

  DoctorsBloc({required DoctorRepository repository})
    : _repository = repository,
      super(DoctorsInitial()) {
    on<FetchDoctorsEvent>(_onFetchDoctors);
    on<SearchDoctorsEvent>(_onSearchDoctors);
  }

  Future<void> _onFetchDoctors(
    FetchDoctorsEvent event,
    Emitter<DoctorsState> emit,
  ) async {
    emit(DoctorsLoading());
    final result = await _repository.getAllDoctors();
    result.fold(
      (failure) => emit(DoctorsError(failure.message)),
      (doctors) => emit(DoctorsLoaded(doctors)),
    );
  }

  Future<void> _onSearchDoctors(
    SearchDoctorsEvent event,
    Emitter<DoctorsState> emit,
  ) async {
    emit(DoctorsLoading());
    final result = await _repository.searchDoctors(event.query);
    result.fold(
      (failure) => emit(DoctorsError(failure.message)),
      (doctors) => emit(DoctorsLoaded(doctors)),
    );
  }
}
