import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:safejourney/model/booking_form.dart';

@immutable
abstract class BookingformState {
  final BookingForm bookingForm;
  BookingformState(this.bookingForm, [List props = const []]);
}

class BookingFormInital extends BookingformState {
  BookingFormInital(BookingForm bookingForm) : super(bookingForm);
}

class BookingFormLoading extends BookingformState {
  BookingFormLoading(BookingForm bookingForm) : super(bookingForm);
}

class SeatNumberSelected extends BookingformState {
  final int seatNumber;

  SeatNumberSelected(this.seatNumber, BookingForm bookingForm)
      : super(bookingForm, [seatNumber]);
}

class SeatNumberDeSelected extends BookingformState {
  final int seatNumber;

  SeatNumberDeSelected(this.seatNumber, BookingForm bookingForm)
      : super(bookingForm, [seatNumber]);
}

class BookingFormUpdated extends BookingformState {
  final BookingForm bookingForm;

  BookingFormUpdated(this.bookingForm) : super(bookingForm);
}

class BookingFormSaveLoading extends BookingformState {
  BookingFormSaveLoading(BookingForm bookingForm) : super(bookingForm);
  @override
  String toString() => 'BookingFormSaveLoading';
}

class BookingFormSaveFailure extends BookingformState {
  final String error;

  BookingFormSaveFailure({@required this.error, BookingForm bookingForm})
      : super(bookingForm, [error]);

  @override
  String toString() => 'BookingFormSaveFailure { error: $error }';
}

class BookingFormSaveSuccess extends BookingformState {
  final String bookingReference;
  BookingFormSaveSuccess(
      {@required this.bookingReference, BookingForm bookingForm})
      : super(bookingForm, [bookingReference]);

  @override
  String toString() =>
      'BookingFormSaveSuccess { Reference: $bookingReference }';
}
