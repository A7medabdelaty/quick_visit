import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'routes/app_router.dart';
import 'routes/route_constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepositoryImpl(),
      child: BlocProvider(
        create:
            (context) =>
                AuthBloc(authRepository: context.read<AuthRepositoryImpl>())
                  ..add(AuthCheckStatusEvent()),
        lazy: false,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Service Reservation',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.lightTheme,
          themeMode: ThemeMode.system,
          initialRoute: RouteConstants.splash,
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );
  }
}
