// To parse this JSON data, do
//
//     final bookingStatusResponse = bookingStatusResponseFromJson(jsonString);

import 'dart:convert';

BookingStatusResponse bookingStatusResponseFromJson(String str) => BookingStatusResponse.fromJson(json.decode(str));

String bookingStatusResponseToJson(BookingStatusResponse data) => json.encode(data.toJson());

class BookingStatusResponse {
  bool success;
  Data data;
  int status;
  int recordsFound;

  BookingStatusResponse({
    this.success,
    this.data,
    this.status,
    this.recordsFound,
  });

  factory BookingStatusResponse.fromJson(Map<String, dynamic> json) => BookingStatusResponse(
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
  String customerName;
  String phoneNo;
  String email;
  double amount;
  String bookingRef;
  String seatNumber;
  String title;
  String couponCode;
  String percentageValue;
  String startDate;
  String endDate;
  String tenantName;
  String paymentMethod;
  String paymentReference;
  String tripDate;
  DateTime bookingDate;
  String nextOfKinName;
  String nkEmail;
  String nkPhoneNo;
  String payload;
  String bookingStatus;
  String departureId;
  String destinationId;
  String departure;
  String destination;
  String departureTime;
  int tenantId;
  String bookingSource;
  String busName;

  Data({
    this.customerName,
    this.phoneNo,
    this.email,
    this.amount,
    this.bookingRef,
    this.seatNumber,
    this.title,
    this.couponCode,
    this.percentageValue,
    this.startDate,
    this.endDate,
    this.tenantName,
    this.paymentMethod,
    this.paymentReference,
    this.tripDate,
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    customerName: json["CustomerName"] == null ? null : json["CustomerName"],
    phoneNo: json["PhoneNo"] == null ? null : json["PhoneNo"],
    email: json["Email"] == null ? null : json["Email"],
    amount: json["Amount"] == null ? null : json["Amount"],
    bookingRef: json["BookingRef"] == null ? null : json["BookingRef"],
    seatNumber: json["SeatNumber"] == null ? null : json["SeatNumber"],
    title: json["Title"] == null ? null : json["Title"],
    couponCode: json["CouponCode"] == null ? null : json["CouponCode"],
    percentageValue: json["PercentageValue"] == null ? null : json["PercentageValue"],
    startDate: json["StartDate"] == null ? null : json["StartDate"],
    endDate: json["EndDate"] == null ? null : json["EndDate"],
    tenantName: json["TenantName"] == null ? null : json["TenantName"],
    paymentMethod: json["PaymentMethod"] == null ? null : json["PaymentMethod"],
    paymentReference: json["PaymentReference"] == null ? null : json["PaymentReference"],
    tripDate: json["TripDate"] == null ? null : json["TripDate"],
    bookingDate: json["BookingDate"] == null ? null : DateTime.parse(json["BookingDate"]),
    nextOfKinName: json["NextOfKinName"] == null ? null : json["NextOfKinName"],
    nkEmail: json["NKEmail"] == null ? null : json["NKEmail"],
    nkPhoneNo: json["NKPhoneNo"] == null ? null : json["NKPhoneNo"],
    payload: json["Payload"] == null ? null : json["Payload"],
    bookingStatus: json["BookingStatus"] == null ? null : json["BookingStatus"],
    departureId: json["DepartureId"] == null ? null : json["DepartureId"],
    destinationId: json["DestinationId"] == null ? null : json["DestinationId"],
    departure: json["Departure"] == null ? null : json["Departure"],
    destination: json["Destination"] == null ? null : json["Destination"],
    departureTime: json["DepartureTime"] == null ? null : json["DepartureTime"],
    tenantId: json["TenantID"] == null ? null : json["TenantID"],
    bookingSource: json["BookingSource"] == null ? null : json["BookingSource"],
    busName: json["BusName"] == null ? null : json["BusName"],
  );

  Map<String, dynamic> toJson() => {
    "CustomerName": customerName,
    "PhoneNo": phoneNo,
    "Email": email,
    "Amount": amount,
    "BookingRef": bookingRef,
    "SeatNumber": seatNumber,
    "Title": title,
    "CouponCode": couponCode,
    "PercentageValue": percentageValue,
    "StartDate": startDate,
    "EndDate": endDate,
    "TenantName": tenantName,
    "PaymentMethod": paymentMethod,
    "PaymentReference": paymentReference,
    "TripDate": tripDate,
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
