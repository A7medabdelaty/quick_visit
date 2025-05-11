import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/features/auth/presentation/pages/base_auth_page.dart';
import 'package:service_reservation_system/features/auth/presentation/widgets/auth_form.dart';
import 'package:service_reservation_system/features/auth/presentation/widgets/auth_page_container.dart';
import 'package:service_reservation_system/features/auth/presentation/widgets/auth_submit_button.dart';

import '../../../../routes/route_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../mixins/fade_animation_mixin.dart';
import '../widgets/auth_text_field.dart';

class ResetPasswordPage extends BaseAuthPage {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends BaseAuthPageState<ResetPasswordPage>
    with FadeAnimationMixin {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  String get title => 'Reset Password';

  @override
  Widget buildForm(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AuthPageContainer(
          title: title,
          child: AuthForm(
            formKey: formKey,
            animation: fadeAnimation,
            children: [
              Image.asset('assets/images/logo.png', width: 100, height: 100),
              const SizedBox(height: 32),
              AuthTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AuthSubmitButton(
                state: state,
                label: 'Reset Password',
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    FirebaseAuth.instance.sendPasswordResetEmail(
                      email: _emailController.text.trim(),
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset email sent'),
                        ),
                      );
                      Navigator.pushReplacementNamed(context, RouteConstants.login);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed:
                    () => Navigator.pushReplacementNamed(
                      context,
                      RouteConstants.login,
                    ),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onAuthenticationSuccess(BuildContext context) {
    Navigator.pushReplacementNamed(context, RouteConstants.login);
  }
}
