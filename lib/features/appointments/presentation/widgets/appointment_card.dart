import 'package:flutter/material.dart';
import 'package:service_reservation_system/core/constants/asset_paths.dart';
import 'package:service_reservation_system/core/theme/app_colors.dart';

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String location;
  final String imageUrl;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final bool showActions;
  final int? daysAgo;

  const AppointmentCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.location,
    this.imageUrl = AssetPaths.doctorPlaceholder,
    this.onReschedule,
    this.onCancel,
    this.showActions = true,
    this.daysAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (daysAgo != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                '$daysAgo Days Ago',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(imageUrl)),
                borderRadius: BorderRadius.circular(12),
              ),
              width: 80,
              height: 80,
            ),
            title: Text(
              doctorName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(specialty),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.calendar_today, date),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.access_time, time),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_on, location),
              ],
            ),
          ),
          if (showActions) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: onReschedule,
                    color: AppColors.successLight,
                    textColor: Colors.white,
                    child: const Text('Reschedule'),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: onCancel,
                    color: AppColors.errorLight,
                    textColor: Colors.white,
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ],
          if (!showActions)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // TODO :: Handle add review
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successLight,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add A Review',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
