// To parse this JSON data, do
//
//     final stateTerminalResponse = stateTerminalResponseFromJson(jsonString);

import 'dart:convert';

StateTerminalResponse stateTerminalResponseFromJson(String str) => StateTerminalResponse.fromJson(json.decode(str));

String stateTerminalResponseToJson(StateTerminalResponse data) => json.encode(data.toJson());

class StateTerminalResponse {
  bool success;
  List<Datum> data;
  int status;
  int recordsFound;

  StateTerminalResponse({
    this.success,
    this.data,
    this.status,
    this.recordsFound,
  });

  factory StateTerminalResponse.fromJson(Map<String, dynamic> json) => new StateTerminalResponse(
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
  String stateName;
  int stateId;
  int terminalId;
  bool isActive;
  String stateTerminalName;
  String terminalName;
  String terminalAddress;
  String contactName;
  String contactEmail;
  String contactPhone;
  String createdBy;
  DateTime createdDate;
  String lastUpdatedBy;
  DateTime lastUpdatedDate;

  Datum({
    this.id,
    this.stateName,
    this.stateId,
    this.terminalId,
    this.isActive,
    this.stateTerminalName,
    this.terminalName,
    this.terminalAddress,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.createdBy,
    this.createdDate,
    this.lastUpdatedBy,
    this.lastUpdatedDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
    id: json["Id"],
    stateName: json["StateName"],
    stateId: json["StateId"],
    terminalId: json["TerminalId"],
    isActive: json["IsActive"],
    stateTerminalName: json["StateTerminalName"],
    terminalName: json["TerminalName"],
    terminalAddress: json["TerminalAddress"],
    contactName: json["ContactName"],
    contactEmail: json["ContactEmail"],
    contactPhone: json["ContactPhone"],
    createdBy: json["CreatedBy"],
    createdDate: DateTime.parse(json["CreatedDate"]),
    lastUpdatedBy: json["LastUpdatedBy"],
    lastUpdatedDate: json["LastUpdatedDate"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "StateName": stateName,
    "StateId": stateId,
    "TerminalId": terminalId,
    "IsActive": isActive,
    "StateTerminalName": stateTerminalName,
    "TerminalName": terminalName,
    "TerminalAddress": terminalAddress,
    "ContactName": contactName,
    "ContactEmail": contactEmail,
    "ContactPhone": contactPhone,
    "CreatedBy": createdBy,
    "CreatedDate": createdDate.toIso8601String(),
    "LastUpdatedBy": lastUpdatedBy,
    "LastUpdatedDate": lastUpdatedDate,
  };
}
