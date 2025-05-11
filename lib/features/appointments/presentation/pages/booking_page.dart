import 'package:flutter/material.dart';
import 'package:service_reservation_system/core/services/date_service.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment_status.dart';
import 'package:service_reservation_system/features/appointments/domain/models/patient_details.dart';
import 'package:service_reservation_system/features/appointments/presentation/pages/payment_details_page.dart';
import 'package:service_reservation_system/features/appointments/presentation/widgets/add_patient_bottom_sheet.dart';
import 'package:service_reservation_system/features/doctors/domain/models/doctor.dart';

class BookingPage extends StatefulWidget {
  final Doctor doctor;

  const BookingPage({super.key, required this.doctor});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedDay;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${widget.doctor.firstName} ${widget.doctor.lastName}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(widget.doctor.specialty),
                    Text(
                      'Consultation Fee: EGP ${widget.doctor.consultationFee}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Select Day', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    widget.doctor.availability.keys.map((day) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            day.substring(0, 1).toUpperCase() +
                                day.substring(1),
                          ),
                          selected: selectedDay == day,
                          onSelected: (selected) {
                            setState(() {
                              selectedDay = selected ? day : null;
                              selectedTime = null;
                            });
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
            if (selectedDay != null) ...[
              const SizedBox(height: 24),
              Text(
                'Select Time',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _generateTimeSlots(selectedDay!).map((time) {
                      return ChoiceChip(
                        label: Text(time),
                        selected: selectedTime == time,
                        onSelected: (selected) {
                          setState(() {
                            selectedTime = selected ? time : null;
                          });
                        },
                      );
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed:
              (selectedDay != null && selectedTime != null)
                  ? () => _bookAppointment(context)
                  : null,
          child: const Text('Book Appointment'),
        ),
      ),
    );
  }

  List<String> _generateTimeSlots(String day) {
    final timeRanges = widget.doctor.availability[day] ?? [];
    final Map<String, List<String>> availability = {day: timeRanges};

    final slots = DateService.generateAvailableSlotsFromDoctor(availability);
    return slots[day] ?? [];
  }

  void _bookAppointment(BuildContext context) {
    if (selectedDay == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both day and time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final DateTime appointmentDate = DateService.getNextWeekday(selectedDay!);
    final String formattedDate = DateService.formatDateDDMMYYYY(
      appointmentDate,
    );

    showModalBottomSheet<PatientDetails>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddPatientBottomSheet(),
    ).then((patientDetails) {
      if (patientDetails != null) {
        final appointment = Appointment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          doctorId: widget.doctor.id,
          patientId: '', // This will be set after user authentication
          doctorName: '${widget.doctor.firstName} ${widget.doctor.lastName}',
          patientName: '${patientDetails.firstName} ${patientDetails.lastName}',
          specialty: widget.doctor.specialty,
          selectedDate: formattedDate,
          selectedTime: selectedTime!,
          consultationFee: widget.doctor.consultationFee,
          location: widget.doctor.clinicName,
          status: AppointmentStatus.pending,
          createdAt: DateTime.now(),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PaymentDetailsPage(
                  doctorName: appointment.doctorName,
                  specialty: appointment.specialty,
                  location: appointment.location,
                  consultingFee: widget.doctor.consultationFee,
                  appointment: appointment,
                  patientDetails: patientDetails,
                ),
          ),
        );
      }
    });
  }
}
