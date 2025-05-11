import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_event.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_state.dart';
import 'package:service_reservation_system/features/appointments/presentation/widgets/appointment_card.dart';
import 'package:service_reservation_system/features/appointments/presentation/widgets/empty_appointments.dart';
import 'package:service_reservation_system/features/appointments/presentation/widgets/reschedule_dialog.dart';
import 'package:service_reservation_system/features/doctors/data/repositories/doctor_repository_impl.dart';

class AppointmentList extends StatelessWidget {
  final bool isActive;

  const AppointmentList({super.key, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AppointmentError) {
          return Center(child: Text(state.message));
        } else if (state is AppointmentSuccess) {
          if (state.appointments.isEmpty) {
            return const EmptyAppointments();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.appointments.length,
            itemBuilder:
                (context, index) =>
                    _buildAppointmentCard(state.appointments[index], context),
          );
        }

        return const Center(child: Text('No appointments found'));
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment, BuildContext context) {
    final List<String> dateParts = appointment.selectedDate.split('/');
    final DateTime appointmentDate = DateTime(
      int.parse(dateParts[2]),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
    );

    final DateTime now = DateTime.now();
    final int? daysAgo =
        isActive ? null : now.difference(appointmentDate).inDays;

    final DateFormat dateFormatter = DateFormat('dd MMM yyyy');
    final String formattedDate = dateFormatter.format(appointmentDate);

    return AppointmentCard(
      doctorName: appointment.doctorName,
      specialty: appointment.specialty,
      date: formattedDate,
      time: appointment.selectedTime,
      location: appointment.location,
      showActions: isActive,
      daysAgo: daysAgo,
      onReschedule:
          isActive
              ? () {
                _showRescheduleDialog(context, appointment);
              }
              : null,
      onCancel:
          isActive
              ? () {
                _showCancelConfirmation(context, appointment);
              }
              : null,
    );
  }

  void _showRescheduleDialog(BuildContext context, Appointment appointment) {
    final appointmentBloc = BlocProvider.of<AppointmentBloc>(context);

    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider<AppointmentBloc>.value(
            value: appointmentBloc,
            child: RescheduleDialog(
              appointment: appointment,
              doctorRepository: DoctorRepositoryImpl(),
            ),
          ),
    );
  }

  void _showCancelConfirmation(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Cancel Appointment'),
            content: const Text(
              'Are you sure you want to cancel this appointment?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<AppointmentBloc>().add(
                    CancelAppointment(appointment.id),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Appointment canceled successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Yes'),
              ),
            ],
          ),
    );
  }
}
