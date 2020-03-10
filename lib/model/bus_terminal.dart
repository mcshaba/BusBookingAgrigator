// To parse this JSON data, do
//
//     final busListByTerminal = busListByTerminalFromJson(jsonString);

import 'dart:convert';

BusListByTerminal busListByTerminalFromJson(String str) => BusListByTerminal.fromJson(json.decode(str));

String busListByTerminalToJson(BusListByTerminal data) => json.encode(data.toJson());

class BusListByTerminal {
  bool success;
  List<Datum> data;
  int status;
  int recordsFound;

  BusListByTerminal({
    this.success,
    this.data,
    this.status,
    this.recordsFound,
  });

  factory BusListByTerminal.fromJson(Map<String, dynamic> json) => new BusListByTerminal(
    success: json["Success"],
    data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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

class Datum {
  int id;
  String terminalName;
  String terminalAddress;
  String contactName;
  String contactPhone;
  String contactEmail;
  String longitude;
  String lattitude;
  bool isActive;
  String createdBy;
  DateTime createdDate;
  String lastUpdatedBy;
  DateTime lastUpdatedDate;

  Datum({
    this.id,
    this.terminalName,
    this.terminalAddress,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.longitude,
    this.lattitude,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.lastUpdatedBy,
    this.lastUpdatedDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
    id: json["ID"],
    terminalName: json["TerminalName"],
    terminalAddress: json["TerminalAddress"],
    contactName: json["ContactName"],
    contactPhone: json["ContactPhone"],
    contactEmail: json["ContactEmail"],
    longitude: json["Longitude"],
    lattitude: json["Lattitude"],
    isActive: json["IsActive"],
    createdBy: json["CreatedBy"],
    createdDate: DateTime.parse(json["CreatedDate"]),
    lastUpdatedBy: json["LastUpdatedBy"],
    lastUpdatedDate: json["LastUpdatedDate"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "TerminalName": terminalName,
    "TerminalAddress": terminalAddress,
    "ContactName": contactName,
    "ContactPhone": contactPhone,
    "ContactEmail": contactEmail,
    "Longitude": longitude,
    "Lattitude": lattitude,
    "IsActive": isActive,
    "CreatedBy": createdBy,
    "CreatedDate": createdDate.toIso8601String(),
    "LastUpdatedBy": lastUpdatedBy,
    "LastUpdatedDate": lastUpdatedDate,
  };
}
