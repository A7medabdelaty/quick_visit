import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_reservation_system/features/appointments/presentation/bloc/appointment_event.dart';
import 'package:service_reservation_system/features/appointments/presentation/widgets/appointment_list.dart';

import '../../data/repositories/appointment_repository_impl.dart';
import '../bloc/appointment_bloc.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AppointmentBloc _appointmentBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _appointmentBloc = AppointmentBloc(repository: AppointmentRepositoryImpl())
      ..add(FetchActiveAppointments());

    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.index == 0) {
      _appointmentBloc.add(FetchActiveAppointments());
    } else {
      _appointmentBloc.add(FetchPreviousAppointments());
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _appointmentBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _appointmentBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Appointments'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [Tab(text: 'Actives'), Tab(text: 'Previews')],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            AppointmentList(isActive: true),
            AppointmentList(isActive: false),
          ],
        ),
      ),
    );
  }
}
