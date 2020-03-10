// To parse this JSON data, do
//
//     final paymentVerificationResponse = paymentVerificationResponseFromJson(jsonString);

import 'dart:convert';

PaymentVerificationResponse paymentVerificationResponseFromJson(String str) => PaymentVerificationResponse.fromJson(json.decode(str));

String paymentVerificationResponseToJson(PaymentVerificationResponse data) => json.encode(data.toJson());

class PaymentVerificationResponse {
  bool success;
  Data data;
  int status;
  int recordsFound;

  PaymentVerificationResponse({
    this.success,
    this.data,
    this.status,
    this.recordsFound,
  });

  factory PaymentVerificationResponse.fromJson(Map<String, dynamic> json) => new PaymentVerificationResponse(
    success: json["Success"],
    data: Data.fromJson(json["data"]),
    status: json["Status"],
    recordsFound: json["RecordsFound"],
  );

  Map<String, dynamic> toJson() => {
    "Success": success,
    "data": data.toJson(),
    "Status": status,
    "RecordsFound": recordsFound,
  };
}

class Data {
  int id;
  int virtualBusId;
  String bookingRef;
  String customerName;
  String email;
  String phoneNo;
  int coupon;
  int amount;
  String departureTime;
  String departure;
  String destination;
  int departureId;
  int destinationId;
  String tenantName;
  int tenantId;
  dynamic isPrimaryDependant;
  int seatNumber;
  int bookingStatus;
  int source;
  String paymentMethod;
  String paymentReference;
  DateTime bookingDate;
  String nextOfKinName;
  String nkPhoneNo;
  String nkEmail;
  String payload;

  Data({
    this.id,
    this.virtualBusId,
    this.bookingRef,
    this.customerName,
    this.email,
    this.phoneNo,
    this.coupon,
    this.amount,
    this.departureTime,
    this.departure,
    this.destination,
    this.departureId,
    this.destinationId,
    this.tenantName,
    this.tenantId,
    this.isPrimaryDependant,
    this.seatNumber,
    this.bookingStatus,
    this.source,
    this.paymentMethod,
    this.paymentReference,
    this.bookingDate,
    this.nextOfKinName,
    this.nkPhoneNo,
    this.nkEmail,
    this.payload,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
    id: json["ID"],
    virtualBusId: json["VirtualBusID"],
    bookingRef: json["BookingRef"],
    customerName: json["CustomerName"],
    email: json["Email"],
    phoneNo: json["PhoneNo"],
    coupon: json["Coupon"],
    amount: json["Amount"],
    departureTime: json["DepartureTime"],
    departure: json["Departure"],
    destination: json["Destination"],
    departureId: json["DepartureId"],
    destinationId: json["DestinationId"],
    tenantName: json["TenantName"],
    tenantId: json["TenantId"],
    isPrimaryDependant: json["IsPrimaryDependant"],
    seatNumber: json["SeatNumber"],
    bookingStatus: json["BookingStatus"],
    source: json["Source"],
    paymentMethod: json["PaymentMethod"],
    paymentReference: json["PaymentReference"],
    bookingDate: DateTime.parse(json["BookingDate"]),
    nextOfKinName: json["NextOfKinName"],
    nkPhoneNo: json["NKPhoneNo"],
    nkEmail: json["NKEmail"],
    payload: json["Payload"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "VirtualBusID": virtualBusId,
    "BookingRef": bookingRef,
    "CustomerName": customerName,
    "Email": email,
    "PhoneNo": phoneNo,
    "Coupon": coupon,
    "Amount": amount,
    "DepartureTime": departureTime,
    "Departure": departure,
    "Destination": destination,
    "DepartureId": departureId,
    "DestinationId": destinationId,
    "TenantName": tenantName,
    "TenantId": tenantId,
    "IsPrimaryDependant": isPrimaryDependant,
    "SeatNumber": seatNumber,
    "BookingStatus": bookingStatus,
    "Source": source,
    "PaymentMethod": paymentMethod,
    "PaymentReference": paymentReference,
    "BookingDate": bookingDate.toIso8601String(),
    "NextOfKinName": nextOfKinName,
    "NKPhoneNo": nkPhoneNo,
    "NKEmail": nkEmail,
    "Payload": payload,
  };
}
