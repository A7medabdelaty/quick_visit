import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_reservation_system/core/services/firebase/firestore_service.dart';
import 'package:service_reservation_system/core/services/firebase/query_filter.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';
import 'package:service_reservation_system/features/appointments/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final FirestoreService _firestoreService;
  static const String slotsCollection = 'slots';
  static const String appointmentsCollection = 'appointments';

  BookingRepositoryImpl({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService.instance;

  @override
  Future<List<DateTime>> getAvailableSlots(
    String doctorId,
    DateTime date,
  ) async {
    final slots = await _firestoreService.query(
      '$slotsCollection/$doctorId/slots',
      (data) => (data['time'] as Timestamp).toDate(),
      filters: [
        QueryFilter(
          field: 'date',
          value: date,
          operator: FilterOperator.isEqualTo,
        ),
      ],
    );
    return slots;
  }

  @override
  Future<void> bookAppointment(String doctorId, DateTime dateTime) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('User not authenticated');

    await _firestoreService.create(appointmentsCollection, null, {
      'doctorId': doctorId,
      'patientId': currentUser.uid,
      'dateTime': dateTime,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<Appointment>> getAppointments(bool isActive) {
    // TODO: implement getAppointments
    throw UnimplementedError();
  }
}
