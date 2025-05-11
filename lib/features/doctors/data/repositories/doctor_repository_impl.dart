import 'package:dartz/dartz.dart';
import 'package:service_reservation_system/core/services/firebase/query_filter.dart';

import '../../../../core/error_handling/failure.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../../domain/models/doctor.dart';
import '../../domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final FirestoreService _firestoreService;

  DoctorRepositoryImpl({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService.instance;

  @override
  Future<Either<Failure, List<Doctor>>> getAllDoctors() async {
    try {
      final doctors = await _firestoreService.query('doctors', Doctor.fromMap);
      return Right(doctors);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Doctor>>> getTopDoctors() async {
    try {
      final doctors = await _firestoreService.query(
        'doctors',
        Doctor.fromMap,
        orderBy: 'rating',
        descending: true,
        limit: 5,
      );
      return Right(doctors);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Doctor>>> searchDoctors(String query) async {
    try {
      final allDoctorsResult = await getAllDoctors();

      return allDoctorsResult.fold((failure) => Left(failure), (doctors) {
        final lowercaseQuery = query.toLowerCase();
        final filteredDoctors =
            doctors.where((doctor) {
              return doctor.name.toLowerCase().contains(lowercaseQuery) ||
                  doctor.specialty.toLowerCase().contains(lowercaseQuery);
            }).toList();

        return Right(filteredDoctors);
      });
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Doctor>>> getDoctorsBySpecialty(
    String specialty,
  ) async {
    try {
      final doctors = await _firestoreService.query(
        'doctors',
        Doctor.fromMap,
        filters: [
          QueryFilter(
            field: 'specialty',
            value: specialty,
            operator: FilterOperator.isEqualTo,
          ),
        ],
      );
      return Right(doctors);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Doctor>> getDoctorById(String doctorId) async {
    try {
      final doctor = await _firestoreService.read(
        'doctors',
        doctorId,
        Doctor.fromMap,
      );

      if (doctor == null) {
        return Left(ServerFailure('Doctor not found'));
      }

      return Right(doctor);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
