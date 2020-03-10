import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:safejourney/model/search_bus_model.dart';
import 'package:safejourney/utilities/validators.dart';

class BookingForm extends Equatable {
  List<String> seats;
  int availableSeats;
  String passengerName;
  String passengerEmail;
  String passengerPhone;
  String passengerKinName;
  String passengerKinEmail;
  String passengerKinPhone;
  DateTime tripDate;
  BusSchedule schedule;
  double tripAmount;
  String coupon;

  bool isFormCompleted() {
    if (seats.isNotEmpty &&
        passengerEmail.isNotEmpty &&
        passengerName.isNotEmpty &&
        passengerPhone.isNotEmpty
    // passengerKinName.isNotEmpty &&
    // passengerKinEmail.isNotEmpty &&
    // passengerKinPhone.isNotEmpty
    ) {
      return true;
    }
    return false;
  }

  bool isPassengerEmailValid() {
    return Validators.isValidEmail(passengerEmail);
  }

  bool isPassengerPhoneValid() {
    return Validators.isValidPhone(passengerPhone);
  }

  bool isPassengerNameValid() {
    return passengerName.isNotEmpty;
  }

  bool isKinNameValid() {
    return passengerKinName.isNotEmpty;
  }

  bool isKinEmailValid() {
    return Validators.isValidEmail(passengerKinEmail);
  }

  bool isKinPhoneValid() {
    return Validators.isValidPhone(passengerKinPhone);
  }

  BookingForm({@required this.seats,
    @required this.passengerName,
    @required this.passengerEmail,
    @required this.passengerPhone,
    @required this.passengerKinName,
    @required this.passengerKinEmail,
    @required this.passengerKinPhone,
    @required this.schedule,
    @required this.tripAmount,
    @required this.coupon,
    @required this.availableSeats})
      : super([
    seats,
    passengerName,
    passengerEmail,
    passengerPhone,
    passengerKinName,
    passengerKinEmail,
    passengerKinPhone,
    schedule,
    tripAmount,
    availableSeats
  ]);

  factory BookingForm.fromJson(Map<String, dynamic> json) =>
      BookingForm(seats: json["seats"],
          passengerName: json["passengerName"],
          passengerEmail: json["passengerEmail"],
          passengerPhone: json["passengerPhone"],
          passengerKinName: json["passengerKinName"],
          passengerKinEmail: json["passengerKinEmail"],
          passengerKinPhone: json["passengerKinPhone"],
          schedule: json["schedule"],
          tripAmount: json["tripAmount"],
          coupon: json["coupon"],
          availableSeats: json["availableSeats"]);

  Map<String, dynamic> toJson() =>
      {
        "passengerName": passengerName,
        "passengerEmail": passengerEmail,
        "passengerPhone": passengerPhone,
        "tripAmount": tripAmount,
        "schedule" : schedule.toJson()
      };

  @override
  String toString() {
    return super.toString();
  }
}
