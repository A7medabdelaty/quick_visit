abstract class AuthEvent {}

class AuthSignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInWithEmailEvent({required this.email, required this.password});
}

class AuthSignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phone;

  AuthSignUpWithEmailEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });
}

class AuthSignOutEvent extends AuthEvent {}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthErrorEvent extends AuthEvent {
  final String message;

  AuthErrorEvent(this.message);
}
