// To parse this JSON data, do
//
//     final topDestination = topDestinationFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

List<TopDestination> topDestinationFromJson(String str) => List<TopDestination>.from(json.decode(str).map((x) => TopDestination.fromJson(x)));

String topDestinationToJson(List<TopDestination> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopDestination extends Equatable{
  String name;
  String img;
  String details;

  TopDestination({
    this.name,
    this.img,
    this.details,
  });

  factory TopDestination.fromJson(Map<String, dynamic> json) => TopDestination(
    name: json["name"],
    img: json["img"],
    details: json["details"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "img": img,
    "details": details,
  };
}
