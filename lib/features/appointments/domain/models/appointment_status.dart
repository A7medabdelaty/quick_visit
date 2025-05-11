enum AppointmentStatus {
  pending,
  active,
  finished,
  canceled;

  String get displayName {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.active:
        return 'Active';
      case AppointmentStatus.finished:
        return 'Finished';
      case AppointmentStatus.canceled:
        return 'Canceled';
    }
  }

  static AppointmentStatus fromString(String status) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => AppointmentStatus.pending,
    );
  }
}
