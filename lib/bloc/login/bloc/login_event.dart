import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent  {
  LoginEvent([List props = const []]);
}

//*Notifies the bloc that the user has changed the phone number
class PhoneNumberChanged extends LoginEvent {
  final String phoneNumber;

  PhoneNumberChanged({@required this.phoneNumber}) : super([phoneNumber]);

  @override
  String toString() => 'PhoneNumberChanged { phone :$phoneNumber }';
}

//*Notifies the bloc that the user has changed the verification code
class VerificationCodeChanged extends LoginEvent {
  final String code;

  VerificationCodeChanged({@required this.code}) : super([code]);

  @override
  String toString() => 'VerificationCodeChanged { code: $code }';
}

//*Notifies the bloc that the user has pressed the login with phone button
class LoginWithPhonePressed extends LoginEvent {
  final String phoneNumber;

  LoginWithPhonePressed({@required this.phoneNumber}) : super([phoneNumber]);

  @override
  String toString() => 'LoginWithPhonePressed { phone :$phoneNumber }';
}

//*Notifies the bloc that the user has pressed the skip/ login as guest button
class LoginAsGuestPressed extends LoginEvent {
  @override
  String toString() => 'LoginAsGuestPressed';
}

//*Notifies the bloc that the user has pressed the verify code button
class VerifyCodePressed extends LoginEvent {
  final String code;

  VerifyCodePressed({@required this.code}) : super([code]);

  @override
  String toString() => 'VerifyCodePressed { code: $code }';
}
