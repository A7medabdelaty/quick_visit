import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/features/auth/presentation/pages/base_auth_page.dart';
import 'package:service_reservation_system/features/auth/presentation/widgets/auth_form.dart';
import 'package:service_reservation_system/features/auth/presentation/widgets/auth_page_container.dart';
import 'package:service_reservation_system/features/auth/presentation/widgets/auth_submit_button.dart';

import '../../../../routes/route_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../mixins/fade_animation_mixin.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends BaseAuthPage {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseAuthPageState<LoginPage>
    with FadeAnimationMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _stayLoggedIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  String get title => 'Login';

  @override
  Widget buildForm(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AuthPageContainer(
          title: title,
          showAppBar: false,
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
              const SizedBox(height: 16),
              AuthTextField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _stayLoggedIn,
                    onChanged: (value) {
                      setState(() => _stayLoggedIn = value ?? false);
                    },
                  ),
                  const Text('Stay logged in'),
                  const Spacer(),
                  TextButton(
                    onPressed:
                        () => Navigator.pushNamed(
                          context,
                          RouteConstants.resetPassword,
                        ),
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AuthSubmitButton(
                state: state, // Now state is properly defined from BlocBuilder
                label: 'Login',
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    context.read<AuthBloc>().add(
                      AuthSignInWithEmailEvent(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed:
                    () => Navigator.pushNamed(context, RouteConstants.register),
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onAuthenticationSuccess(BuildContext context) {
    Navigator.pushReplacementNamed(context, RouteConstants.home);
  }
}
