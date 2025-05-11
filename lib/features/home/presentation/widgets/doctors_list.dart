import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/core/widgets/section_header.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/top_doctors_bloc.dart';
import 'package:service_reservation_system/features/doctors/presentation/pages/doctor_details_page.dart';
import 'package:service_reservation_system/features/doctors/presentation/widgets/doctor_card.dart';

class DoctorsList extends StatelessWidget {
  const DoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopDoctorsBloc, TopDoctorsState>(
      builder: (context, state) {
        return Column(
          children: [
            SectionHeader(title: 'Top Doctors'),
            if (state is TopDoctorsLoading)
              const Center(child: CircularProgressIndicator()),
            if (state is TopDoctorsError) Center(child: Text(state.message)),
            if (state is TopDoctorsLoaded)
              ...state.doctors.map(
                (doctor) => DoctorCard(
                  doctor: doctor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetailsPage(doctor: doctor),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
