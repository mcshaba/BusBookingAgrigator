// To parse this JSON data, do
//
//     final bookTransactionResponse = bookTransactionResponseFromJson(jsonString);

import 'dart:convert';

BookTransactionResponse bookTransactionResponseFromJson(String str) => BookTransactionResponse.fromJson(json.decode(str));

String bookTransactionResponseToJson(BookTransactionResponse data) => json.encode(data.toJson());

class BookTransactionResponse {
  String message;
  bool success;
  Data data;
  int status;
  int recordsFound;

  BookTransactionResponse({
    this.success,
    this.data,
    this.status,
    this.message,
    this.recordsFound,
  });

  factory BookTransactionResponse.fromJson(Map<String, dynamic> json) => new BookTransactionResponse(
    success: json["Success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
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
  String customerName;
  String phoneNo;
  String email;
  int amount;
  String bookingRef;
  String title;
  String couponCode;
  dynamic percentageValue;
  DateTime startDate;
  DateTime endDate;
  String tenantName;
  String paymentMethod;
  String paymentReference;
  int seatNumber;
  DateTime bookingDate;
  String nextOfKinName;
  String nkEmail;
  String nkPhoneNo;
  String payload;
  String bookingStatus;
  int departureId;
  int destinationId;
  String departure;
  String destination;
  dynamic departureTime;
  int tenantId;
  String bookingSource;
  String busName;

  Data({
    this.customerName,
    this.phoneNo,
    this.email,
    this.amount,
    this.bookingRef,
    this.title,
    this.couponCode,
    this.percentageValue,
    this.startDate,
    this.endDate,
    this.tenantName,
    this.paymentMethod,
    this.paymentReference,
    this.seatNumber,
    this.bookingDate,
    this.nextOfKinName,
    this.nkEmail,
    this.nkPhoneNo,
    this.payload,
    this.bookingStatus,
    this.departureId,
    this.destinationId,
    this.departure,
    this.destination,
    this.departureTime,
    this.tenantId,
    this.bookingSource,
    this.busName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
    customerName: json["CustomerName"],
    phoneNo: json["PhoneNo"],
    email: json["Email"],
    amount: json["Amount"],
    bookingRef: json["BookingRef"],
    title: json["Title"],
    couponCode: json["CouponCode"],
    percentageValue: json["PercentageValue"],
    startDate: json["StartDate"],
    endDate: json["EndDate"],
    tenantName: json["TenantName"],
    paymentMethod: json["PaymentMethod"],
    paymentReference: json["PaymentReference"],
    seatNumber: json["SeatNumber"],
    bookingDate: DateTime.parse(json["BookingDate"]),
    nextOfKinName: json["NextOfKinName"],
    nkEmail: json["NKEmail"],
    nkPhoneNo: json["NKPhoneNo"],
    payload: json["Payload"],
    bookingStatus: json["BookingStatus"],
    departureId: json["DepartureId"],
    destinationId: json["DestinationId"],
    departure: json["Departure"],
    destination: json["Destination"],
    departureTime: json["DepartureTime"],
    tenantId: json["TenantID"],
    bookingSource: json["BookingSource"],
    busName: json["BusName"],
  );

  Map<String, dynamic> toJson() => {
    "CustomerName": customerName,
    "PhoneNo": phoneNo,
    "Email": email,
    "Amount": amount,
    "BookingRef": bookingRef,
    "Title": title,
    "CouponCode": couponCode,
    "PercentageValue": percentageValue,
    "StartDate": startDate,
    "EndDate": endDate,
    "TenantName": tenantName,
    "PaymentMethod": paymentMethod,
    "PaymentReference": paymentReference,
    "SeatNumber": seatNumber,
    "BookingDate": bookingDate.toIso8601String(),
    "NextOfKinName": nextOfKinName,
    "NKEmail": nkEmail,
    "NKPhoneNo": nkPhoneNo,
    "Payload": payload,
    "BookingStatus": bookingStatus,
    "DepartureId": departureId,
    "DestinationId": destinationId,
    "Departure": departure,
    "Destination": destination,
    "DepartureTime": departureTime,
    "TenantID": tenantId,
    "BookingSource": bookingSource,
    "BusName": busName,
  };
}
