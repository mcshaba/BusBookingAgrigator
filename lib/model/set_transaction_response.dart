// To parse this JSON data, do
//
//     final setTransactonResponse = setTransactonResponseFromJson(jsonString);

import 'dart:convert';

SetTransactonResponse setTransactonResponseFromJson(String str) => SetTransactonResponse.fromJson(json.decode(str));

String setTransactonResponseToJson(SetTransactonResponse data) => json.encode(data.toJson());

class SetTransactonResponse {
    String code;
    bool succeeded;
    Data data;

    SetTransactonResponse({
        this.code,
        this.succeeded,
        this.data,
    });

    factory SetTransactonResponse.fromJson(Map<String, dynamic> json) => new SetTransactonResponse(
        code: json["code"] == null ? null : json["code"],
        succeeded: json["succeeded"] == null ? null : json["succeeded"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "succeeded": succeeded == null ? null : succeeded,
        "data": data == null ? null : data.toJson(),
    };
}

class Data {
    String transactionReference;
    int charge;
    String redirectUrl;

    Data({
        this.transactionReference,
        this.charge,
        this.redirectUrl,
    });

    factory Data.fromJson(Map<String, dynamic> json) => new Data(
        transactionReference: json["transactionReference"] == null ? null : json["transactionReference"],
        charge: json["charge"] == null ? null : json["charge"],
        redirectUrl: json["redirectUrl"] == null ? null : json["redirectUrl"],
    );

    Map<String, dynamic> toJson() => {
        "transactionReference": transactionReference == null ? null : transactionReference,
        "charge": charge == null ? null : charge,
        "redirectUrl": redirectUrl == null ? null : redirectUrl,
    };
}
