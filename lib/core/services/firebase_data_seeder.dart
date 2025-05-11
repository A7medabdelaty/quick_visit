import 'package:service_reservation_system/core/services/firebase/firestore_service.dart';

import '../data/doctors_data.dart';

class FirebaseDataSeeder {
  final FirestoreService _firestoreService;

  FirebaseDataSeeder({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService.instance;

  Future<void> seedDoctors() async {
    try {
      for (final doctorData in doctorsData) {
        await _firestoreService.create('doctors', null, doctorData);
      }
      print('Successfully seeded ${doctorsData.length} doctors');
    } catch (e) {
      print('Error seeding doctors data: $e');
      rethrow;
    }
  }
}
