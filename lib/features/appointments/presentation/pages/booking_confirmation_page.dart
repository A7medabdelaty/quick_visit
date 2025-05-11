import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/features/appointments/data/repositories/appointment_repository_impl.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment_status.dart';
import 'package:service_reservation_system/features/appointments/domain/models/booking_data.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_event.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_state.dart';
import 'package:service_reservation_system/routes/route_constants.dart';

class BookingConfirmationPage extends StatelessWidget {
  final BookingData bookingData;

  const BookingConfirmationPage({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final appointment = Appointment(
      id: bookingData.bookingId,
      doctorId: bookingData.doctorId,
      patientId: user?.uid ?? '',
      doctorName: bookingData.doctorName,
      patientName:
          '${bookingData.patientDetails['firstName']} ${bookingData.patientDetails['lastName']}',
      specialty: bookingData.specialty,
      location: bookingData.location,
      selectedDate: bookingData.selectedDate,
      selectedTime: bookingData.selectedTime,
      consultationFee: bookingData.consultationFee,
      status: AppointmentStatus.active,
      createdAt: DateTime.now(),
    );

    return BlocProvider(
      create:
          (context) =>
              AppointmentBloc(repository: AppointmentRepositoryImpl())
                ..add(CreateAppointment(appointment))
                ..add(StoreAppointmentUnderUser(appointment, user?.uid ?? '')),
      child: BlocListener<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Thank You',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your Booking Is Successfully\nCompleted',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Booking Id\n${bookingData.bookingId}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            icon: Icons.download,
                            label: 'Download Invoice',
                            onTap: () {
                              // Handle download invoice
                            },
                          ),
                          const SizedBox(width: 16),
                          _buildActionButton(
                            icon: Icons.share,
                            label: 'Share Invoice',
                            onTap: () {
                              // Handle share invoice
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildDoctorInfo(),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteConstants.home,
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Back To Home Page'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookingData.doctorName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  bookingData.specialty,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        bookingData.location,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle view map
            },
            child: const Text('View Map'),
          ),
        ],
      ),
    );
  }
}
