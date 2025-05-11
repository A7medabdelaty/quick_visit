import 'package:flutter/material.dart';
import 'package:service_reservation_system/core/widgets/custom_button.dart';
import 'package:service_reservation_system/features/appointments/domain/models/appointment.dart';
import 'package:service_reservation_system/features/appointments/domain/models/booking_data.dart';
import 'package:service_reservation_system/features/appointments/domain/models/patient_details.dart';
import 'package:service_reservation_system/features/appointments/presentation/pages/booking_confirmation_page.dart';
import 'package:service_reservation_system/features/appointments/presentation/widgets/add_patient_bottom_sheet.dart';
import 'package:service_reservation_system/features/appointments/presentation/widgets/doctor_info_widget.dart';
import 'package:service_reservation_system/features/appointments/presentation/widgets/payment_details_widget.dart';
import 'package:service_reservation_system/features/appointments/presentation/widgets/terms_conditions_widget.dart';

class PaymentDetailsPage extends StatefulWidget {
  final String doctorName;
  final String specialty;
  final String location;
  final double consultingFee;
  final Appointment appointment;
  final PatientDetails patientDetails;

  const PaymentDetailsPage({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.location,
    required this.consultingFee,
    required this.appointment,
    required this.patientDetails,
  });

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  PatientDetails? patientDetails;

  @override
  void initState() {
    super.initState();
    patientDetails = widget.patientDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Proceed'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoctorInfoWidget(
                doctorName: widget.doctorName,
                specialty: widget.specialty,
                location: widget.location,
              ),
              const SizedBox(height: 24),
              _buildPatientDetails(),
              const SizedBox(height: 24),
              PaymentDetailsWidget(consultingFee: widget.consultingFee),
              const SizedBox(height: 24),
              const TermsConditionsWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBookButton(),
    );
  }

  Widget _buildPatientDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Patient Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            final result = await showModalBottomSheet<PatientDetails>(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder:
                  (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const AddPatientBottomSheet(),
                  ),
            );
            if (result != null) {
              setState(() => patientDetails = result);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  patientDetails == null ? Colors.teal.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child:
                patientDetails == null
                    ? _buildAddPatientButton()
                    : _buildPatientInfo(),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPatientButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.person_add, color: Colors.teal),
        SizedBox(width: 8),
        Text(
          'Add Patient',
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPatientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          patientDetails!.fullName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text('Age: ${patientDetails!.age} years'),
        Text('Gender: ${patientDetails!.gender}'),
        Text('Relation: ${patientDetails!.relation}'),
      ],
    );
  }

  Widget _buildBookButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomButton(
        text: 'Book Appointment',
        onPressed: () {
          final bookingData = BookingData.fromAppointment(
            widget.appointment,
            patientDetails!,
            widget.consultingFee,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      BookingConfirmationPage(bookingData: bookingData),
            ),
          );
        },
        width: double.infinity,
      ),
    );
  }
}
