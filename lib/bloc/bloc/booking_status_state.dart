import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:safejourney/model/booking_status_response.dart';

@immutable
abstract class BookingStatusState extends Equatable {
  BookingStatusState([List props = const <dynamic>[]]) : super(props);
}

class InitialBookingStatusState extends BookingStatusState {}

class BookingStatusLoading extends BookingStatusState {
  @override
  String toString() => 'BookingStatusLoading';
}

class BookingStatusFailure extends BookingStatusState {
  final String error;

  BookingStatusFailure({@required this.error, })
      : super( [error]);

  @override
  String toString() => 'BookingStatusFailure { error: $error }';
}

class BookingStatusSuccess extends BookingStatusState {
  final BookingStatusResponse bookingStatusResponse;
  BookingStatusSuccess(
      { this.bookingStatusResponse})
      : super( [bookingStatusResponse]);

  @override
  String toString() =>
      'BookingStatusSuccess { Reference: $bookingStatusResponse }';
}
