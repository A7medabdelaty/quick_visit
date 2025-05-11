import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

abstract class BaseAuthPage extends StatefulWidget {
  const BaseAuthPage({super.key});
}

abstract class BaseAuthPageState<T extends BaseAuthPage> extends State<T>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  @protected
  Widget buildForm(BuildContext context);

  @protected
  String get title;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthAuthenticated) {
          onAuthenticationSuccess(context);
        }
      },
      builder: (context, state) => buildForm(context),
    );
  }

  @protected
  void onAuthenticationSuccess(BuildContext context);
}
