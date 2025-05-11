import 'package:flutter/material.dart';
import 'package:service_reservation_system/core/constants/asset_paths.dart';
import 'package:service_reservation_system/core/widgets/app_image.dart';
import 'package:service_reservation_system/core/widgets/section_header.dart';
import 'package:service_reservation_system/features/doctors/presentation/pages/specialty_doctors_page.dart';

class TopSpecialties extends StatelessWidget {
  const TopSpecialties({super.key});

  @override
  Widget build(BuildContext context) {
    final specialties = [
      {'title': 'Oncologist', 'image': AssetPaths.topSpecialties[0]},
      {'title': 'Endocrinologist', 'image': AssetPaths.topSpecialties[1]},
      {'title': 'Cardiologist', 'image': AssetPaths.topSpecialties[2]},
      {'title': 'Dermatologist', 'image': AssetPaths.topSpecialties[3]},
      {'title': 'Orthopedic', 'image': AssetPaths.topSpecialties[4]},
      {'title': 'Psychiatrist', 'image': AssetPaths.topSpecialties[5]},
      {'title': 'Pediatrician', 'image': AssetPaths.topSpecialties[6]},
      {'title': 'Radiologist', 'image': AssetPaths.topSpecialties[7]},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Top Specialties'),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: specialties.length,
          itemBuilder:
              (_, index) => _SpecialtyItem(
                title: specialties[index]['title']!,
                imagePath: specialties[index]['image']!,
              ),
        ),
      ],
    );
  }
}

class _SpecialtyItem extends StatelessWidget {
  final String title;
  final String imagePath;

  const _SpecialtyItem({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpecialtyDoctorsPage(specialty: title),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            clipBehavior: Clip.antiAlias,
            child: AppImage(path: imagePath, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
