import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/core/constants/app_strings.dart';
import 'package:service_reservation_system/core/services/date_service.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_event.dart';
import 'package:service_reservation_system/features/doctors/domain/repositories/doctor_repository.dart';

class RescheduleDialog extends StatefulWidget {
  final Appointment appointment;
  final DoctorRepository doctorRepository;

  const RescheduleDialog({
    super.key,
    required this.appointment,
    required this.doctorRepository,
  });

  @override
  State<RescheduleDialog> createState() => _RescheduleDialogState();
}

class _RescheduleDialogState extends State<RescheduleDialog> {
  String? selectedDay;
  String? selectedTime;
  Map<String, List<String>> availableSlots = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDoctorAvailability();
  }

  Future<void> _loadDoctorAvailability() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final doctorResult = await widget.doctorRepository.getDoctorById(
        widget.appointment.doctorId,
      );

      doctorResult.fold(
        (failure) {
          setState(() {
            errorMessage = failure.message;
            isLoading = false;
          });
        },
        (doctor) {
          setState(() {
            availableSlots = DateService.generateAvailableSlotsFromDoctor(
              doctor.availability,
            );
            isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _rescheduleAppointment() {
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

    // Create updated appointment with new date and time
    final updatedAppointment = widget.appointment.copyWith(
      selectedDate: formattedDate,
      selectedTime: selectedTime,
    );

    context.read<AppointmentBloc>().add(
      RescheduleAppointment(widget.appointment.id, updatedAppointment),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.reschedule,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage != null)
              Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (availableSlots.isEmpty)
              Center(child: Text(AppStrings.noAvailableSlots))
            else ...[
              Text(
                'Select Day',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    availableSlots.keys.map((day) {
                      return ChoiceChip(
                        label: Text(day),
                        selected: selectedDay == day,
                        onSelected: (selected) {
                          setState(() {
                            selectedDay = selected ? day : null;
                            selectedTime = null;
                          });
                        },
                      );
                    }).toList(),
              ),
              if (selectedDay != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Select Time',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          availableSlots[selectedDay]!.map((time) {
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
                  ),
                ),
              ],
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppStrings.cancel),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      isLoading ||
                              errorMessage != null ||
                              selectedDay == null ||
                              selectedTime == null
                          ? null
                          : _rescheduleAppointment,
                  child: Text(AppStrings.confirm),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
