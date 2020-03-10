// To parse this JSON data, do
//
//     final stateResponse = stateResponseFromJson(jsonString);

import 'dart:convert';

StateResponse stateResponseFromJson(String str) => StateResponse.fromJson(json.decode(str));

String stateResponseToJson(StateResponse data) => json.encode(data.toJson());

class StateResponse {
  int status;
  int recordsFound;
  bool success;
  List<StateModel> data;

  StateResponse({
    this.status,
    this.recordsFound,
    this.success,
    this.data,
  });

  factory StateResponse.fromJson(Map<String, dynamic> json) => new StateResponse(
    status: json["Status"],
    recordsFound: json["RecordsFound"],
    success: json["Success"],
    data: new List<StateModel>.from(json["data"].map((x) => StateModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "RecordsFound": recordsFound,
    "Success": success,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class StateModel {
  String name;
  String code;
  String capital;

  StateModel({
    this.name,
    this.code,
    this.capital,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => new StateModel(
    name: json["name"],
    code: json["code"],
    capital: json["capital"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "capital": capital,
  };
}
