import 'package:flutter/material.dart';
import 'package:service_reservation_system/core/constants/asset_paths.dart';

class DoctorInfoWidget extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String location;

  const DoctorInfoWidget({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(AssetPaths.doctorPlaceholder),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctorName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(specialty),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text(location)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
