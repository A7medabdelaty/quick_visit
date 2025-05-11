import 'package:flutter/material.dart';
import 'package:service_reservation_system/core/theme/app_colors.dart';

class AppointmentsTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AppointmentsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        tabs: [Tab(text: 'Actives'), Tab(text: 'Previews')],
        indicatorColor: AppColors.tabBarLabelPrimary,
        indicatorWeight: 3,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
