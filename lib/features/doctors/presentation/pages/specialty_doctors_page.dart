import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/specialty_doctors_bloc.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/specialty_doctors_event.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/specialty_doctors_state.dart';
import 'package:service_reservation_system/features/doctors/presentation/pages/doctor_details_page.dart';
import 'package:service_reservation_system/features/doctors/presentation/widgets/doctor_card.dart';

class SpecialtyDoctorsPage extends StatelessWidget {
  final String specialty;

  const SpecialtyDoctorsPage({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              SpecialtyDoctorsBloc(repository: DoctorRepositoryImpl())
                ..add(FetchSpecialtyDoctorsEvent(specialty)),
      child: Scaffold(
        appBar: AppBar(title: Text('$specialty Doctors')),
        body: BlocBuilder<SpecialtyDoctorsBloc, SpecialtyDoctorsState>(
          builder: (context, state) {
            if (state is SpecialtyDoctorsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SpecialtyDoctorsError) {
              return Center(child: Text(state.message));
            } else if (state is SpecialtyDoctorsLoaded) {
              if (state.doctors.isEmpty) {
                return Center(child: Text('No $specialty doctors found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
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
                              (context) => DoctorDetailsPage(doctor: doctor),
                        ),
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
