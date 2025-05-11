import 'package:flutter/material.dart';
import 'package:service_reservation_system/features/appointments/domain/models/patient_details.dart';

class AddPatientBottomSheet extends StatefulWidget {
  const AddPatientBottomSheet({super.key});

  @override
  State<AddPatientBottomSheet> createState() => _AddPatientBottomSheetState();
}

class _AddPatientBottomSheetState extends State<AddPatientBottomSheet> {
  String? selectedGender;
  String selectedRelation = 'Self';
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add A Patient',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
              suffixText: 'Years',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          const Text('Gender'),
          Row(
            children: [
              Radio<String>(
                value: 'Male',
                groupValue: selectedGender,
                onChanged: (value) => setState(() => selectedGender = value),
              ),
              const Text('Male'),
              Radio<String>(
                value: 'Female',
                groupValue: selectedGender,
                onChanged: (value) => setState(() => selectedGender = value),
              ),
              const Text('Female'),
              Radio<String>(
                value: 'Others',
                groupValue: selectedGender,
                onChanged: (value) => setState(() => selectedGender = value),
              ),
              const Text('Others'),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedRelation,
            decoration: const InputDecoration(
              labelText: 'Relation',
              border: OutlineInputBorder(),
            ),
            items:
                ['Self', 'Parent', 'Child', 'Spouse', 'Other']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedRelation = value);
              }
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (firstNameController.text.isNotEmpty &&
                    ageController.text.isNotEmpty) {
                  final patientDetails = PatientDetails(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    age: int.tryParse(ageController.text) ?? 0,
                    gender: selectedGender ?? '',
                    relation: selectedRelation,
                    phoneNumber: '01027975697',
                    email: 'ahmed.abdelaty174@gmail.com',
                  );
                  Navigator.pop(context, patientDetails);
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
