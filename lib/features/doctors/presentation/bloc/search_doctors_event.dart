abstract class SearchDoctorsEvent {}

class SearchDoctorsQueryEvent extends SearchDoctorsEvent {
  final String query;

  SearchDoctorsQueryEvent(this.query);
}

class ClearSearchEvent extends SearchDoctorsEvent {}

class PerformSearchEvent extends SearchDoctorsEvent {
  final String query;

  PerformSearchEvent(this.query);
}
