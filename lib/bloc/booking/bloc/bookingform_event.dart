import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:safejourney/model/booking_form.dart';
import 'package:safejourney/model/post_booking.dart';

@immutable
abstract class BookingformEvent extends Equatable {
  BookingformEvent([List props = const []]) : super(props);
}

class BookingFormStarted extends BookingformEvent {}

class UserAddsToSeat extends BookingformEvent {
  final int seatNumber;

  UserAddsToSeat(this.seatNumber) : super([seatNumber]);
}

class PassengerNameChange extends BookingformEvent {
  final String name;

  PassengerNameChange(this.name) : super([name]);
}

class PassengerEmailChange extends BookingformEvent {
  final String email;

  PassengerEmailChange(this.email) : super([email]);
}

class PassengerPhoneChange extends BookingformEvent {
  final String phone;

  PassengerPhoneChange(this.phone) : super([phone]);
}

class KinNameChange extends BookingformEvent {
  final String name;

  KinNameChange(this.name) : super([name]);
}

class KinEmailChange extends BookingformEvent {
  final String email;

  KinEmailChange(this.email) : super([email]);
}

class KinPhoneChange extends BookingformEvent {
  final String phone;

  KinPhoneChange(this.phone) : super([phone]);
}

class UserRemovesFromSeat extends BookingformEvent {
  final int seatNumber;

  UserRemovesFromSeat(this.seatNumber) : super([seatNumber]);
}

class TripDateChange extends BookingformEvent {
  final DateTime tripDate;

  TripDateChange(this.tripDate) : super([tripDate]);


}

class BookingButtonPressed extends BookingformEvent {
  final BookingForm bookingForm;
  final String transactionReference;
  final String payload;

  BookingButtonPressed(this.bookingForm, this.transactionReference, this.payload) :super ([bookingForm, transactionReference, payload]);

  @override
  String toString() =>
      'BookingButtonPressed  $bookingForm' ;
}
