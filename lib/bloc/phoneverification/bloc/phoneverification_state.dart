import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PhoneverificationState extends Equatable {
  PhoneverificationState([List props = const []]) : super(props);
}

class InitialPhoneverificationState extends PhoneverificationState {}

class InitialCodeverificationState extends PhoneverificationState {}

class PhoneVerificationLoading extends PhoneverificationState {
  @override
  String toString() => 'PhoneVerificationLoading';
}

class CodeVerificationLoading extends PhoneverificationState {
  @override
  String toString() => 'CodeVerificationLoading';
}


class PhoneVerificationFailure extends PhoneverificationState {
   final String error;

  PhoneVerificationFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'PhoneVerificationFailure { error: $error }';
}

class CodeVerificationFailure extends PhoneverificationState {
   final String error;

  CodeVerificationFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'CodeVerificationFailure { error: $error }';
}

class PhoneVerificationSuccess extends PhoneverificationState {
  @override
  String toString() => 'PhoneVerificationSuccess';
}

class CodeVerificationSuccess extends PhoneverificationState {
  @override
  String toString() => 'CodeVerificationSuccess';
}