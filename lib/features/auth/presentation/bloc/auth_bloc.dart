import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<AuthCheckStatusEvent>(_onAuthCheckStatus);
    on<AuthSignInWithEmailEvent>(_onSignInWithEmail);
    on<AuthSignUpWithEmailEvent>(_onSignUpWithEmail);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthErrorEvent>(_onAuthError);

    _setupAuthStateSubscription();
  }

  void _setupAuthStateSubscription() {
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) {
        if (user == null) {
          add(AuthCheckStatusEvent());
        } else {
          user.reload().then((_) {
            add(AuthCheckStatusEvent());
          }).catchError((_) {
            add(AuthSignOutEvent());
          });
        }
      },
      onError: (error) {
        add(AuthErrorEvent(error.toString()));
      },
    );
  }

  Future<void> _onAuthCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        try {
          await user.reload();
          emit(AuthAuthenticated(user));
        } catch (e) {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthError(
    AuthErrorEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthFailure(event.message));
  }

  Future<void> _onSignInWithEmail(
    AuthSignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithEmail(
      event.email,
      event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (userCredential) => emit(AuthAuthenticated(userCredential.user!)),
    );
  }

  Future<void> _onSignUpWithEmail(
    AuthSignUpWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signUpWithEmail(
      event.email,
      event.password,
      event.name,
      event.phone,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (userCredential) => emit(AuthAuthenticated(userCredential.user!)),
    );
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signOut();

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
