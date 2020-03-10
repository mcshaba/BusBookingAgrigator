// To parse this JSON data, do
//
//     final postBooking = postBookingFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

PostBooking postBookingFromJson(String str) =>
    PostBooking.fromJson(json.decode(str));

String postBookingToJson(PostBooking data) => json.encode(data.toJson());

class PostBooking {
  int id;
  int virtualBusId;
  String bookingRef;
  String customerName;
  String email;
  String phoneNo;
  int coupon;
  String departureTime;
  int departureId;
  String destination;
  String departure;
  int destinationId;
  int amount;
  int bookingStatus;
  String idBookingdata;
  int source = 2; //* to show its from mobile
  String paymentMethod;
  String paymentReference;
  String postBookingOperator;
  DateTime bookingDate;
  DateTime tripDate;
  List<String> seatNumber;
  int tenantId;
  bool isPrimaryDependant = true;
  String nextOfKinName;
  String nkPhoneNo;
  String nkEmail;
  String split;
  String payload;
  String createdBy;
  String status;
  String message;
  String st;
  bool isSubmitted = true;
  String uniqueKey;

  PostBooking({
    this.id,
    @required this.virtualBusId,
    @required this.bookingRef,
    @required this.customerName,
    @required this.email,
    @required this.phoneNo,
    @required this.coupon,
    @required this.departureTime,
    @required this.departureId,
    @required this.destination,
    @required this.departure,
    @required this.destinationId,
    @required this.amount,
    @required this.bookingStatus,
    this.idBookingdata,
    this.source,
    this.paymentMethod,
    this.paymentReference,
    this.postBookingOperator,
    @required this.bookingDate,
    @required this.tripDate,
    @required this.seatNumber,
    @required this.tenantId,
    this.isPrimaryDependant,
    @required this.nextOfKinName,
    @required this.nkPhoneNo,
    @required this.nkEmail,
    this.split,
    this.payload,
    this.createdBy,
    @required this.status,
    this.message,
    this.st,
    this.isSubmitted,
    this.uniqueKey,
  });

  factory PostBooking.fromJson(Map<String, dynamic> json) => new PostBooking(
        id: json["ID"],
        virtualBusId: json["VirtualBusID"],
        bookingRef: json["BookingRef"],
        customerName: json["CustomerName"],
        email: json["Email"],
        phoneNo: json["PhoneNo"],
        coupon: json["Coupon"],
        departureTime: json["DepartureTime"],
        departureId: json["DepartureId"],
        destination: json["Destination"],
        departure: json["Departure"],
        destinationId: json["DestinationId"],
        amount: json["Amount"],
        bookingStatus: json["BookingStatus"],
        idBookingdata: json["IdBookingdata"],
        source: json["Source"],
        paymentMethod: json["PaymentMethod"],
        paymentReference: json["PaymentReference"],
        postBookingOperator: json["Operator"],
        bookingDate: DateTime.parse(json["BookingDate"]),
        tripDate: DateTime.parse(json["TripDate"]),
        seatNumber: List<String>.from(json["SeatNumber"].map((x) => x)),
        tenantId: json["TenantId"],
        isPrimaryDependant: json["IsPrimaryDependant"],
        nextOfKinName: json["NextOfKinName"],
        nkPhoneNo: json["NKPhoneNo"],
        nkEmail: json["NKEmail"],
        split: json["Split"],
        payload: json["Payload"],
        createdBy: json["CreatedBy"],
        status: json["Status"],
        message: json["Message"],
        st: json["ST"],
        isSubmitted: json["IsSubmitted"],
        uniqueKey: json["UniqueKey"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "VirtualBusID": virtualBusId,
        "BookingRef": bookingRef,
        "CustomerName": customerName,
        "Email": email,
        "PhoneNo": phoneNo,
        "Coupon": coupon,
        "DepartureTime": departureTime,
        "DepartureId": departureId,
        "Destination": destination,
        "Departure": departure,
        "DestinationId": destinationId,
        "Amount": amount,
        "BookingStatus": bookingStatus,
        "IdBookingdata": idBookingdata,
        "Source": source,
        "PaymentMethod": paymentMethod,
        "PaymentReference": paymentReference,
        "Operator": postBookingOperator,
        "BookingDate": bookingDate.toIso8601String(),
        "TripDate": tripDate.toIso8601String(),
        "SeatNumber": List<dynamic>.from(seatNumber.map((x) => x)),
        "TenantId": tenantId,
        "IsPrimaryDependant": isPrimaryDependant,
        "NextOfKinName": nextOfKinName,
        "NKPhoneNo": nkPhoneNo,
        "NKEmail": nkEmail,
        "Split": split,
        "Payload": payload,
        "CreatedBy": createdBy,
        "Status": status,
        "Message": message,
        "ST": st,
        "IsSubmitted": isSubmitted,
        "UniqueKey": uniqueKey,
      };
}
