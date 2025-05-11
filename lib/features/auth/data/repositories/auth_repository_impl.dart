import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_reservation_system/core/constants/firestore_collections.dart';
import 'package:service_reservation_system/core/services/firebase/firestore_service.dart';

import '../../../../core/error_handling/failure.dart';
import '../../../../core/services/firebase/firebase_auth_helper.dart';
import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthHelper _authHelper;
  final FirestoreService _firestoreService;

  AuthRepositoryImpl()
    : _authHelper = FirebaseAuthHelper.instance,
      _firestoreService = FirestoreService.instance;

  @override
  Future<Either<Failure, UserCredential>> signUpWithEmail(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    try {
      final result = await _authHelper.signUpWithEmail(email, password);

      if (result.user == null) {
        return Left(ServerFailure('Authentication failed: null user returned'));
      }

      try {
        await _createUserInFirestore(result.user!.uid, name, email, phone);
        return Right(result);
      } catch (e) {
        await result.user!.delete();
        return Left(
          ServerFailure('Failed to create user profile: ${e.toString()}'),
        );
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        return Left(ServerFailure(e.message ?? 'Authentication failed'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _createUserInFirestore(
    String uid,
    String name,
    String email,
    String phone,
  ) async {
    final user = domain.User(
      id: uid,
      name: name,
      email: email,
      phone: phone,
      createdAt: DateTime.now(),
    );
    await _firestoreService.create(
      FirestoreCollections.users,
      uid,
      user.toMap(),
    );
  }

  @override
  Stream<User?> get authStateChanges => _authHelper.authStateChanges;

  @override
  User? get currentUser => _authHelper.currentUser;

  @override
  Future<Either<Failure, UserCredential>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final result = await _authHelper.signInWithEmail(email, password);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authHelper.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
