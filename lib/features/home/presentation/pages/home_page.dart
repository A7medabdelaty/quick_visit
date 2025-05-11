import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:service_reservation_system/core/widgets/responsive_layout.dart';
import 'package:service_reservation_system/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/top_doctors_bloc.dart';
import 'package:service_reservation_system/features/doctors/presentation/pages/all_doctors_page.dart';
import 'package:service_reservation_system/features/home/presentation/widgets/doctors_list.dart';
import 'package:service_reservation_system/features/home/presentation/widgets/home_banner.dart';
import 'package:service_reservation_system/features/home/presentation/widgets/home_header.dart';
import 'package:service_reservation_system/features/home/presentation/widgets/home_search_bar.dart';
import 'package:service_reservation_system/features/home/presentation/widgets/top_specialties.dart';

import '../../../../features/appointments/presentation/pages/appointments_page.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/home_bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationController(),
      child: BlocProvider(
        create:
            (context) =>
                TopDoctorsBloc(repository: DoctorRepositoryImpl())
                  ..add(FetchTopDoctors()),
        child: Consumer<NavigationController>(
          builder: (context, controller, _) {
            return Scaffold(
              body: IndexedStack(
                index: controller.currentIndex,
                children: [
                  ResponsiveLayout(
                    mobile: _HomeMobileView(),
                    tablet: _HomeTabletView(),
                    desktop: _HomeDesktopView(),
                  ),
                  const MyAppointmentsPage(),
                  const AllDoctorsPage(),
                  const Center(child: Text('Profile Page')),
                ],
              ),
              bottomNavigationBar: const HomeBottomNav(),
            );
          },
        ),
      ),
    );
  }
}

class _HomeMobileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeader(),
          HomeSearchBar(),
          SizedBox(height: 8),
          HomeBanner(),
          TopSpecialties(),
          DoctorsList(),
        ],
      ),
    );
  }
}

class _HomeTabletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(),
          const HomeSearchBar(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: const [HomeBanner(), TopSpecialties()],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(flex: 2, child: DoctorsList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeDesktopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(),
          const HomeSearchBar(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: const [HomeBanner(), TopSpecialties()],
                  ),
                ),
                SizedBox(width: 24),
                Expanded(child: DoctorsList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
