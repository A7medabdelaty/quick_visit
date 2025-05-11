import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/features/auth/domain/services/auth_validation_service.dart';
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

class RegisterPage extends BaseAuthPage {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseAuthPageState<RegisterPage>
    with FadeAnimationMixin {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _validationService = AuthValidationService();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  String get title => 'Register';

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
                controller: _nameController,
                label: 'Full Name',
                validator: _validationService.validateName,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                  if ((value?.length ?? 0) < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AuthSubmitButton(
                state: state,
                label: 'Register',
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    context.read<AuthBloc>().add(
                      AuthSignUpWithEmailEvent(
                        email: _emailController.text,
                        password: _passwordController.text,
                        name: _nameController.text,
                        phone: _phoneController.text,
                      ),
                    );
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
                child: const Text('Already have an account? Login'),
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
