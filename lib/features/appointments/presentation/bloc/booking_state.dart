abstract class BookingState {
  const BookingState();
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingSuccess extends BookingState {
  final List<DateTime> availableSlots;

  const BookingSuccess(this.availableSlots);
}

class BookingConfirmed extends BookingState {
  const BookingConfirmed();
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);
}
