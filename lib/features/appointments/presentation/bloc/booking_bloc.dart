import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/features/appointments/domain/repositories/booking_repository.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/booking_state.dart';

class BookingBloc extends Cubit<BookingState> {
  final BookingRepository _repository;

  BookingBloc(this._repository) : super(BookingInitial());

  Future<void> loadAvailableSlots(String doctorId, DateTime date) async {
    emit(BookingLoading());
    try {
      final slots = await _repository.getAvailableSlots(doctorId, date);
      emit(BookingSuccess(slots));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> bookAppointment(String doctorId, DateTime dateTime) async {
    emit(BookingLoading());
    try {
      await _repository.bookAppointment(doctorId, dateTime);
      emit(BookingConfirmed());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
