abstract class DoctorsEvent {}

class FetchDoctorsEvent extends DoctorsEvent {}

class SearchDoctorsEvent extends DoctorsEvent {
  final String query;
  SearchDoctorsEvent(this.query);
}
