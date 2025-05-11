import 'package:intl/intl.dart';

class Doctor {
  final String id;
  final String firstName;
  final String lastName;
  final String specialty;
  final List<String> qualifications;
  final int experience;
  final String profileImage;
  final String clinicName;
  final DoctorLocation location;
  final double consultationFee;
  final double rating;
  final int totalRatings;
  final Map<String, List<String>> availability;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialty,
    required this.qualifications,
    required this.experience,
    required this.profileImage,
    required this.clinicName,
    required this.location,
    required this.consultationFee,
    required this.rating,
    required this.totalRatings,
    required this.availability,
  });

  String get name => '$firstName $lastName';

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      specialty: map['specialty'] ?? '',
      qualifications: List<String>.from(map['qualifications'] ?? []),
      experience: map['experience']?.toInt() ?? 0,
      profileImage: map['profileImage'] ?? '',
      clinicName: map['clinicName'] ?? '',
      location: DoctorLocation.fromMap(map['location'] ?? {}),
      consultationFee: (map['consultationFee'] ?? 0.0).toDouble(),
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalRatings: map['totalRatings']?.toInt() ?? 0,
      availability: Map<String, List<String>>.from(
        (map['availability'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(
            key,
            (value as List).map((slot) => slot.toString()).toList(),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'specialty': specialty,
      'qualifications': qualifications,
      'experience': experience,
      'profileImage': profileImage,
      'clinicName': clinicName,
      'location': location.toMap(),
      'consultationFee': consultationFee,
      'rating': rating,
      'totalRatings': totalRatings,
      'availability': availability,
    };
  }

  // Helper method to generate time slots for a given time range
  static List<TimeSlot> generateTimeSlots(String startTime, String endTime) {
    final format = DateFormat('HH:mm');
    final start = format.parse(startTime);
    final end = format.parse(endTime);

    final slots = <TimeSlot>[];
    var current = start;

    while (current.isBefore(end)) {
      final slotEnd = current.add(const Duration(minutes: 15));
      if (!slotEnd.isAfter(end)) {
        slots.add(
          TimeSlot(
            startTime: format.format(current),
            endTime: format.format(slotEnd),
            isBooked: false,
          ),
        );
      }
      current = slotEnd;
    }

    return slots;
  }
}

class DoctorLocation {
  final String address;
  final double latitude;
  final double longitude;

  const DoctorLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory DoctorLocation.fromMap(Map<String, dynamic> map) {
    return DoctorLocation(
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'address': address, 'latitude': latitude, 'longitude': longitude};
  }
}

class TimeSlot {
  final String startTime;
  final String endTime;
  final bool isBooked;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      isBooked: map['isBooked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'startTime': startTime, 'endTime': endTime, 'isBooked': isBooked};
  }
}
