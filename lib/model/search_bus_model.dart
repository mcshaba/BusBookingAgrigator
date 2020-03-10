// To parse this JSON data, do
//
//     final searchBusResponse = searchBusResponseFromJson(jsonString);

import 'dart:convert';

SearchBusResponse searchBusResponseFromJson(String str) => SearchBusResponse.fromJson(json.decode(str));

String searchBusResponseToJson(SearchBusResponse data) => json.encode(data.toJson());

class SearchBusResponse {
  bool success;
  List<BusSchedule> data;
  int status;
  int recordsFound;

  SearchBusResponse({
    this.success,
    this.data,
    this.status,
    this.recordsFound,
  });

  factory SearchBusResponse.fromJson(Map<String, dynamic> json) => new SearchBusResponse(
    success: json["Success"],
    data: new List<BusSchedule>.from(json["data"].map((x) => BusSchedule.fromJson(x))),
    status: json["Status"],
    recordsFound: json["RecordsFound"],
  );

  Map<String, dynamic> toJson() => {
    "Success": success,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
    "Status": status,
    "RecordsFound": recordsFound,
  };
}

class BusSchedule {
  int busScheduleId;
  int virtualBusId;
  String busName;
  DateTime tripdate;
  int departureId;
  int destinationId;
  int seatCapacity;
  String blockedSeats;
  String destination;
  String facilities;
  String departure;
  String departureTime;
  String route;
  double actualPrice;
  double promoPrice;
  List<String> bookedSeats;
  String allBookedSeats;
  int bookedSeatsCount;
  int availableSeatsCount;
  List<String> unavailableSeats;
  String destinationTerminal;
  String departureTerminal;
  String tenantLogo;
  String tenantName;
  int tenantId;
  int noOfAdult;
  List<MySplit> mySplit;
  String integrationKey;

  BusSchedule({
    this.busScheduleId,
    this.virtualBusId,
    this.busName,
    this.tripdate,
    this.departureId,
    this.destinationId,
    this.seatCapacity,
    this.blockedSeats,
    this.destination,
    this.facilities,
    this.departure,
    this.departureTime,
    this.route,
    this.actualPrice,
    this.promoPrice,
    this.allBookedSeats,
    this.bookedSeats,
    this.bookedSeatsCount,
    this.availableSeatsCount,
    this.unavailableSeats,
    this.destinationTerminal,
    this.departureTerminal,
    this.tenantLogo,
    this.tenantName,
    this.tenantId,
    this.noOfAdult,
    this.mySplit,
    this.integrationKey,
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) => new BusSchedule(
    busScheduleId: json["BusScheduleId"] == null ? null : json["BusScheduleId"],
    virtualBusId: json["VirtualBusId"] == null ? null : json["VirtualBusId"],
    busName: json["BusName"] == null ? null : json["BusName"],
    tripdate: json["Tripdate"] == null ? null : DateTime.parse(json["Tripdate"]),
    departureId: json["DepartureId"] == null ? null : json["DepartureId"],
    destinationId: json["DestinationId"] == null ? null : json["DestinationId"],
    seatCapacity: json["SeatCapacity"]  == null ? null :  json["SeatCapacity"],
    blockedSeats: json["BlockedSeats"] == null ? null : json["BlockedSeats"],
    destination: json["Destination"] == null ? null : json["Destination"],
    facilities: json["Facilities"] == null ? null : json["Facilities"],
    departure: json["Departure"]  == null ? null : json["Departure"],
    departureTime: json["DepartureTime"] == null ? null :  json["DepartureTime"],
    route: json["Route"] == null ? null : json["Route"],
    actualPrice: json["ActualPrice"] == null ? null : json["ActualPrice"],
    promoPrice: json["PromoPrice"] == null ? null :  json["PromoPrice"],
    bookedSeats: json["BookedSeats"] == null ? null :  new List<String>.from(json["BookedSeats"].map((x) => x)),
    allBookedSeats: json["AllBookedSeats"] == null ? null :  json["AllBookedSeats"],
    bookedSeatsCount: json["BookedSeatsCount"] == null ? null : json["BookedSeatsCount"],
    availableSeatsCount: json["AvailableSeatsCount"] == null ? null : json["AvailableSeatsCount"],
    unavailableSeats: new List<String>.from(json["UnavailableSeats"].map((x) => x)),
    destinationTerminal: json["DestinationTerminal"] == null ? null : json["DestinationTerminal"],
    departureTerminal: json["DepartureTerminal"] == null ? null : json["DepartureTerminal"],
    tenantLogo: json["TenantLogo"] == null ? null : json["TenantLogo"],
    tenantName: json["TenantName"] == null ? null : json["TenantName"],
    tenantId: json["TenantId"] == null ? null : json["TenantId"],
    noOfAdult: json["noOfAdult"] == null ? null : json["noOfAdult"],
    integrationKey: json["integrationKey"],
    mySplit: List<MySplit>.from(json["MySplit"].map((x) => MySplit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "BusScheduleId": busScheduleId,
    "VirtualBusId": virtualBusId,
    "BusName": busName,
    "Tripdate": tripdate.toIso8601String(),
    "DepartureId": departureId,
    "DestinationId": destinationId,
    "SeatCapacity": seatCapacity,
    "BlockedSeats": blockedSeats,
    "Destination": destination,
    "Facilities": facilities,
    "Departure": departure,
    "DepartureTime": departureTime,
    "Route": route,
    "ActualPrice": actualPrice,
    "PromoPrice": promoPrice,
    "BookedSeats": new List<dynamic>.from(bookedSeats.map((x) => x)),
    "BookedSeatsCount": bookedSeatsCount,
    "AvailableSeatsCount": availableSeatsCount,
    "UnavailableSeats": new List<dynamic>.from(unavailableSeats.map((x) => x)),
    "AllBookedSeats": allBookedSeats,
    "DestinationTerminal": destinationTerminal,
    "DepartureTerminal": departureTerminal,
    "TenantLogo": tenantLogo,
    "TenantName": tenantName,
    "TenantId": tenantId,
    "noOfAdult": noOfAdult,
    "integrationKey": integrationKey,
    "MySplit": List<dynamic>.from(mySplit.map((x) => x.toJson())),
  };
}

class MySplit {
  String walletCode;
  double amount;
  bool shouldDeductFrom;

  MySplit({
    this.walletCode,
    this.amount,
    this.shouldDeductFrom,
  });

  factory MySplit.fromJson(Map<String, dynamic> json) => MySplit(
    walletCode: json["walletCode"],
    amount: json["Amount"],
    shouldDeductFrom: json["ShouldDeductFrom"],
  );

  Map<String, dynamic> toJson() => {
    "walletCode": walletCode,
    "Amount": amount,
    "ShouldDeductFrom": shouldDeductFrom,
  };
}

