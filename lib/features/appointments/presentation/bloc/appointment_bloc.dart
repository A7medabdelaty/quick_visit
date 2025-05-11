import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/core/services/firebase/firebase_auth_helper.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment_status.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_event.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_state.dart';

import '../../domain/models/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository _repository;

  AppointmentBloc({required AppointmentRepository repository})
    : _repository = repository,
      super(AppointmentInitial()) {
    on<FetchActiveAppointments>(_onFetchActiveAppointments);
    on<FetchPreviousAppointments>(_onFetchPreviousAppointments);
    on<CreateAppointment>(_onCreateAppointment);
    on<CancelAppointment>(_onCancelAppointment);
    on<RescheduleAppointment>(_onRescheduleAppointment);
    on<StoreAppointmentUnderUser>(_onStoreAppointmentUnderUser);
  }

  Future<void> _onFetchActiveAppointments(
    FetchActiveAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(AppointmentLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AppointmentError('User not authenticated'));
        return;
      }

      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('appointments')
              .where('status', isEqualTo: 'active')
              .orderBy('selectedDate', descending: false)
              .get();

      final appointments =
          snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList();

      emit(AppointmentSuccess(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onFetchPreviousAppointments(
    FetchPreviousAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(AppointmentLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AppointmentError('User not authenticated'));
        return;
      }

      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('appointments')
              .where('status', isEqualTo: 'completed')
              .orderBy('selectedDate', descending: true)
              .get();

      final appointments =
          snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList();

      emit(AppointmentSuccess(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onCreateAppointment(
    CreateAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoading());
      await _repository.createAppointment(event.appointment);
      final appointments = await _repository.getActiveAppointments(
        'currentUserId',
      );
      emit(AppointmentSuccess(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onRescheduleAppointment(
    RescheduleAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoading());
      await _repository.rescheduleAppointment(
        event.appointmentId,
        event.newDateTime.selectedDate,
        event.newDateTime.selectedTime,
      );

      final user = FirebaseAuthHelper.instance.currentUser;
      if (user == null) {
        emit(AppointmentError('User not authenticated'));
        return;
      }

      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('appointments')
              .where('status', isEqualTo: 'active')
              .orderBy('selectedDate', descending: false)
              .get();

      final appointments =
          snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList();

      emit(AppointmentSuccess(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onCancelAppointment(
    CancelAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(AppointmentLoading());

      await _repository.updateAppointmentStatus(
        event.appointmentId,
        AppointmentStatus.canceled,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AppointmentError('User not authenticated'));
        return;
      }

      final appointments = await _repository.getActiveAppointments(user.uid);

      emit(AppointmentSuccess(appointments));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _onStoreAppointmentUnderUser(
    StoreAppointmentUnderUser event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(event.userId)
          .collection('appointments')
          .doc(event.appointment.id)
          .set(event.appointment.toMap());
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }
}
