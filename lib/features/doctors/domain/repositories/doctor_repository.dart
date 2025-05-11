import 'package:dartz/dartz.dart';

import '../../../../core/error_handling/failure.dart';
import '../models/doctor.dart';

abstract class DoctorRepository {
  Future<Either<Failure, List<Doctor>>> getAllDoctors();
  Future<Either<Failure, List<Doctor>>> getTopDoctors();
  Future<Either<Failure, List<Doctor>>> searchDoctors(String query);
  Future<Either<Failure, List<Doctor>>> getDoctorsBySpecialty(String specialty);
  Future<Either<Failure, Doctor>> getDoctorById(String doctorId);
}
