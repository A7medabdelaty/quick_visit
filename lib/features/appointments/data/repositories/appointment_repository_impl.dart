import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment_status.dart';

import '../../domain/models/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AppointmentRepositoryImpl({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<void> createAppointment(Appointment appointment) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _firestore
        .collection('appointments')
        .doc(appointment.id)
        .set(appointment.toMap());

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('appointments')
        .doc(appointment.id)
        .set(appointment.toMap());
  }

  @override
  Future<List<Appointment>> getActiveAppointments(String userId) async {
    final snapshot =
        await _firestore
            .collection('appointments')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 'active')
            .get();

    return snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList();
  }

  @override
  Future<List<Appointment>> getPreviousAppointments(String userId) async {
    final snapshot =
        await _firestore
            .collection('appointments')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 'completed')
            .get();

    return snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList();
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'cancelled',
    });
  }

  @override
  Future<void> rescheduleAppointment(
    String appointmentId,
    String newDate,
    String newTime,
  ) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _firestore.collection('appointments').doc(appointmentId).update({
      'selectedDate': newDate,
      'selectedTime': newTime,
    });

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('appointments')
        .doc(appointmentId)
        .update({'selectedDate': newDate, 'selectedTime': newTime});
  }

  @override
  Future<void> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('appointments')
        .doc(appointmentId)
        .update({'status': status.name});
  }
}
