import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/core/constants/asset_paths.dart';
import 'package:service_reservation_system/core/extensions/build_context_extension.dart';
import 'package:service_reservation_system/core/widgets/app_image.dart';
import 'package:service_reservation_system/features/auth/presentation/bloc/auth_event.dart';
import 'package:service_reservation_system/features/splash/presentation/widgets/loading_painter.dart';

import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../routes/route_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthStatus();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.repeat();
  }

  void _checkAuthStatus() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        context.read<AuthBloc>().add(AuthCheckStatusEvent());
      }
    });
  }

  void _handleNavigation(BuildContext context, String route) {
    if (!_controller.isCompleted) {
      _controller.forward().then((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, route);
        }
      });
    } else {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _handleNavigation(context, RouteConstants.home);
          } else if (state is AuthUnauthenticated) {
            _handleNavigation(context, RouteConstants.login);
          }
        },
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppImage(
                        path: AssetPaths.logo,
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CustomPaint(
                          painter: LoadingPainter(
                            animation: _loadingAnimation,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Quick Visit',
                        style: TextStyle(
                          fontSize: context.sp(28),
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Book appointments easily',
                        style: TextStyle(
                          fontSize: context.sp(16),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
