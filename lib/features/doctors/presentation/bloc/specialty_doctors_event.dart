abstract class SpecialtyDoctorsEvent {}

class FetchSpecialtyDoctorsEvent extends SpecialtyDoctorsEvent {
  final String specialty;

  FetchSpecialtyDoctorsEvent(this.specialty);
}
