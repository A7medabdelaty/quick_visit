import 'package:flutter/material.dart';
import 'package:service_reservation_system/core/extensions/build_context_extension.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllTap;
  final EdgeInsetsGeometry padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAllTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: context.sp(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          // if (onViewAllTap != null)
          //   GestureDetector(
          //     onTap: onViewAllTap,
          //     child: Text(
          //       'View All',
          //       style: TextStyle(color: Colors.blue, fontSize: context.sp(14)),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
