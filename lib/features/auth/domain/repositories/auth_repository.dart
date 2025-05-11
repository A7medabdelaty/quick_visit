import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error_handling/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserCredential>> signInWithEmail(
    String email,
    String password,
  );
  Future<Either<Failure, UserCredential>> signUpWithEmail(
    String email,
    String password,
    String name,
    String phone,
  );
  Future<Either<Failure, void>> signOut();
  Stream<User?> get authStateChanges;
  User? get currentUser;
}
