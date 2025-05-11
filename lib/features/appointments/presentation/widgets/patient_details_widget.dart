import 'package:flutter/material.dart';

import '../../domain/models/patient_details.dart';

class PatientDetailsWidget extends StatelessWidget {
  final PatientDetails? patientDetails;
  final VoidCallback onTap;

  const PatientDetailsWidget({
    super.key,
    this.patientDetails,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: patientDetails == null ? Colors.teal.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child:
            patientDetails == null
                ? _buildAddPatientButton()
                : _buildPatientInfo(),
      ),
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
}
