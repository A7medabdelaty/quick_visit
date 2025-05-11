import 'package:flutter/material.dart';

import '../bloc/auth_state.dart';

class AuthSubmitButton extends StatelessWidget {
  final AuthState state;
  final String label;
  final VoidCallback? onPressed;

  const AuthSubmitButton({
    super.key,
    required this.state,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: state is AuthLoading ? null : onPressed,
      child:
          state is AuthLoading
              ? const CircularProgressIndicator()
              : Text(label),
    );
  }
}
