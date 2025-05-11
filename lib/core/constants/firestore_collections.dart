/// Constants for Firestore collection names
class FirestoreCollections {
  // Private constructor to prevent instantiation
  FirestoreCollections._();

  // User related collections
  static const String users = 'users';

  // Doctor related collections
  static const String doctors = 'doctors';
  static const String slots = 'slots';

  // Appointment related collections
  static const String appointments = 'appointments';

  // Sub-collections
  static const String doctorSlots = '$doctors/$slots';

  // Helper method to get doctor's slots collection
  static String getDoctorSlotsPath(String doctorId) => '$doctors/$doctorId/$slots';
}