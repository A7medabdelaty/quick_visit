import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/core/extensions/build_context_extension.dart';
import 'package:service_reservation_system/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/search_doctors_bloc.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/search_doctors_event.dart';
import 'package:service_reservation_system/features/doctors/presentation/bloc/search_doctors_state.dart';
import 'package:service_reservation_system/features/doctors/presentation/pages/doctor_details_page.dart';
import 'package:service_reservation_system/features/doctors/presentation/widgets/doctor_card.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  late final SearchDoctorsBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchDoctorsBloc(repository: DoctorRepositoryImpl());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildSearchBar(),
            ),
          ),
        ),
        body: BlocBuilder<SearchDoctorsBloc, SearchDoctorsState>(
          builder: (context, state) {
            if (state is SearchDoctorsInitial) {
              return const Center(
                child: Text('Search for doctors or specialties'),
              );
            } else if (state is SearchDoctorsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchDoctorsError) {
              return Center(child: Text(state.message));
            } else if (state is SearchDoctorsLoaded) {
              if (state.doctors.isEmpty) {
                return Center(
                  child: Text('No results found for "${state.query}"'),
                );
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
                          builder: (context) => DoctorDetailsPage(doctor: doctor),
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (query) {
          _searchBloc.add(SearchDoctorsQueryEvent(query));
        },
        decoration: InputDecoration(
          hintText: 'Search doctors, specialties...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: context.sp(14),
          ),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[600]),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey[600]),
            onPressed: () {
              _searchController.clear();
              _searchBloc.add(ClearSearchEvent());
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
