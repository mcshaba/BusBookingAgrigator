import 'dart:convert';

LoginResponse loginResponseFromJson(String string) =>
    LoginResponse.fromJson(json.decode(string));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool status;
  String message;
  Data data;
  String error;

  LoginResponse({
    this.status,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      new LoginResponse(
          status: json["status"],
          message: json["message"],
          data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String responseCode;
  String responseMessage;
  User user;

  Data({this.responseCode, this.responseMessage, this.user});

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
        responseCode: json["ResponseCode"],
        responseMessage: json["ResponseMessage"],
        user: User.fromJson(json["User"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "ResponseMessage": responseMessage,
        "User": user.toJson(),
      };
}

class User {
  String name;
  int phoneNumber;
  String errorMessage;
  String token;

  User({this.name, this.phoneNumber, this.errorMessage, this.token});

  factory User.fromJson(Map<String, dynamic> json) => new User(
        name: json["Name"],
        phoneNumber: json["Phone"],
        errorMessage: json["ErrorMessage"],
        token: json["Token"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Phone": phoneNumber,
        "ErrorMessage": errorMessage,
        "Token": token,
      };
}
