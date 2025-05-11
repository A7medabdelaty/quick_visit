import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/doctors_bloc.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/doctors_event.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/doctors_state.dart';
import 'package:service_reservation_system/features/doctors/presentation/pages/doctor_details_page.dart';

import '../widgets/doctor_card.dart';
import '../widgets/doctors_search_bar.dart';

class AllDoctorsPage extends StatelessWidget {
  const AllDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              DoctorsBloc(repository: DoctorRepositoryImpl())
                ..add(FetchDoctorsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Doctors'),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Handle menu action
              },
            ),
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<DoctorsBloc, DoctorsState>(
              builder: (context, state) {
                return DoctorsSearchBar(
                  location: 'West Ham',
                  onLocationTap: () {
                    // Handle location selection
                  },
                  onChanged: (query) {
                    context.read<DoctorsBloc>().add(SearchDoctorsEvent(query));
                  },
                );
              },
            ),
            Expanded(
              child: BlocBuilder<DoctorsBloc, DoctorsState>(
                builder: (context, state) {
                  if (state is DoctorsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is DoctorsError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is DoctorsLoaded) {
                    return ListView.builder(
                      itemCount: state.doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = state.doctors[index];
                        return DoctorCard(
                          doctor: doctor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        DoctorDetailsPage(doctor: doctor),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const Center(child: Text('No doctors available'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
