import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/doctor_repository.dart';
import 'search_doctors_event.dart';
import 'search_doctors_state.dart';

class SearchDoctorsBloc extends Bloc<SearchDoctorsEvent, SearchDoctorsState> {
  final DoctorRepository repository;
  Timer? _debounce;
  String _lastQuery = '';

  SearchDoctorsBloc({required this.repository})
    : super(SearchDoctorsInitial()) {
    on<SearchDoctorsQueryEvent>(_onSearchQueryChanged);
    on<PerformSearchEvent>(_onPerformSearch);
    on<ClearSearchEvent>(_onClearSearch);
  }

  void _onSearchQueryChanged(
    SearchDoctorsQueryEvent event,
    Emitter<SearchDoctorsState> emit,
  ) {
    _lastQuery = event.query;
    _debounce?.cancel();

    if (event.query.trim().isEmpty) {
      emit(SearchDoctorsInitial());
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => add(PerformSearchEvent(_lastQuery)),
    );
  }

  Future<void> _onPerformSearch(
    PerformSearchEvent event,
    Emitter<SearchDoctorsState> emit,
  ) async {
    emit(SearchDoctorsLoading());
    final result = await repository.searchDoctors(event.query);
    result.fold(
      (failure) => emit(SearchDoctorsError(failure.message)),
      (doctors) => emit(SearchDoctorsLoaded(doctors, event.query)),
    );
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchDoctorsState> emit,
  ) {
    emit(SearchDoctorsInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
