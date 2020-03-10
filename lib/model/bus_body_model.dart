// To parse this JSON data, do
//
//     final busModel = busModelFromJson(jsonString);

import 'dart:convert';

BusModel busModelFromJson(String str) => BusModel.fromJson(json.decode(str));

String busModelToJson(BusModel data) => json.encode(data.toJson());

class BusModel {
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
  int source;
  String paymentMethod;
  String paymentReference;
  String busModelOperator;
  DateTime bookingDate;
  int seatNumber;
  int tenantId;
  bool isPrimaryDependant;
  String nextOfKinName;
  String nkPhoneNo;
  String nkEmail;
  String split;
  String payload;
  String createdBy;
  String status;
  String message;
  String st;
  bool isSubmitted;
  String uniqueKey;

  BusModel({
    this.id,
    this.virtualBusId,
    this.bookingRef,
    this.customerName,
    this.email,
    this.phoneNo,
    this.coupon,
    this.departureTime,
    this.departureId,
    this.destination,
    this.departure,
    this.destinationId,
    this.amount,
    this.bookingStatus,
    this.idBookingdata,
    this.source,
    this.paymentMethod,
    this.paymentReference,
    this.busModelOperator,
    this.bookingDate,
    this.seatNumber,
    this.tenantId,
    this.isPrimaryDependant,
    this.nextOfKinName,
    this.nkPhoneNo,
    this.nkEmail,
    this.split,
    this.payload,
    this.createdBy,
    this.status,
    this.message,
    this.st,
    this.isSubmitted,
    this.uniqueKey,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) => new BusModel(
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
    busModelOperator: json["Operator"],
    bookingDate: DateTime.parse(json["BookingDate"]),
    seatNumber: json["SeatNumber"],
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
    "Operator": busModelOperator,
    "BookingDate": bookingDate.toIso8601String(),
    "SeatNumber": seatNumber,
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
