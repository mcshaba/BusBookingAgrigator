// To parse this JSON data, do
//
//     final bookingResponse = bookingResponseFromJson(jsonString);

import 'dart:convert';

BookingResponse bookingResponseFromJson(String str) => BookingResponse.fromJson(json.decode(str));

String bookingResponseToJson(BookingResponse data) => json.encode(data.toJson());

class BookingResponse {
    int id;
    int virtualBusId;
    String bookingRef;
    String customerName;
    String email;
    String phoneNo;
    int coupon;
    double amount;
    String departureTime;
    String tripDate;
    String departure;
    String destination;
    int departureId;
    int destinationId;
    String tenantName;
    int tenantId;
    dynamic isPrimaryDependant;
    String seatNumber;
    int bookingStatus;
    int source;
    String paymentMethod;
    String paymentReference;
    DateTime bookingDate;
    String nextOfKinName;
    String nkPhoneNo;
    String nkEmail;
    dynamic payload;

    BookingResponse({
        this.id,
        this.virtualBusId,
        this.bookingRef,
        this.customerName,
        this.email,
        this.phoneNo,
        this.coupon,
        this.amount,
        this.departureTime,
        this.tripDate,
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

    factory BookingResponse.fromJson(Map<String, dynamic> json) => new BookingResponse(
        id: json["ID"],
        virtualBusId: json["VirtualBusID"],
        bookingRef: json["BookingRef"],
        customerName: json["CustomerName"],
        email: json["Email"],
        phoneNo: json["PhoneNo"],
        coupon: json["Coupon"],
        amount: json["Amount"],
        departureTime: json["DepartureTime"],
        tripDate: json["TripDate"],
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
        "TripDate": tripDate,
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
