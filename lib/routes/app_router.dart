import 'package:flutter/material.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';
import 'package:service_reservation_system/features/appointments/domain/models/patient_details.dart';
import 'package:service_reservation_system/features/appointments/presentation/pages/appointments_page.dart';
import 'package:service_reservation_system/features/appointments/presentation/pages/booking_page.dart';
import 'package:service_reservation_system/features/appointments/presentation/pages/payment_details_page.dart';
import 'package:service_reservation_system/features/auth/presentation/pages/reset_password_page.dart';
import 'package:service_reservation_system/features/doctors/presentation/pages/all_doctors_page.dart';
import 'package:service_reservation_system/features/doctors/presentation/pages/doctor_details_page.dart';

import '../core/presentation/pages/error_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import 'route_constants.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Widget page;
    bool useSlideTransition = true;

    switch (settings.name) {
      case RouteConstants.splash:
        page = const SplashPage();
        useSlideTransition = false; // Use fade for splash
        break;

      case RouteConstants.home:
        page = const HomePage();
        break;

      case RouteConstants.login:
        page = const LoginPage();
        useSlideTransition = false; // Use fade for auth pages
        break;

      case RouteConstants.register:
        page = const RegisterPage();
        useSlideTransition = false;
        break;

      case RouteConstants.resetPassword:
        page = const ResetPasswordPage();
        break;

      case RouteConstants.allDoctors:
        page = const AllDoctorsPage();
        break;

      case RouteConstants.doctorDetails:
        if (args is Map<String, dynamic>) {
          page = DoctorDetailsPage(doctor: args['doctor']);
        } else {
          page = const ErrorPage(message: 'Invalid doctor details arguments');
        }
        break;

      case RouteConstants.bookAppointment:
        if (args is Map<String, dynamic>) {
          page = BookingPage(doctor: args['doctor']);
        } else {
          page = const ErrorPage(message: 'Invalid booking arguments');
        }
        break;

      case RouteConstants.paymentDetails:
        if (args is Map<String, dynamic>) {
          page = PaymentDetailsPage(
            patientDetails: args['patientDetails'] as PatientDetails,
            appointment: args['appointment'] as Appointment,
            doctorName: args['doctorName'] as String,
            specialty: args['specialty'] as String,
            location: args['location'] as String,
            consultingFee: args['consultingFee'] as double,
          );
        } else {
          page = const ErrorPage(message: 'Invalid payment details arguments');
        }
        break;

      case RouteConstants.myAppointments:
        page = const MyAppointmentsPage();
        break;

      default:
        page = const ErrorPage(message: 'Route not found');
    }

    if (useSlideTransition) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    // Fade transition for auth pages
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
