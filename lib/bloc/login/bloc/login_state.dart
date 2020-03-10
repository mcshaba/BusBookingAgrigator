import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class LoginState  {
  final bool isPhoneValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String error;
  // bool get isFormValid => isPhoneValid;

  LoginState({
    @required this.isPhoneValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    this.error
  });

  //*The initial state of the login form
  factory LoginState.empty() {
    return LoginState(
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  //*The state of the form when validating login credentials
  factory LoginState.loading() {
    return LoginState(
      isPhoneValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  //*The state of the form when a login attempt has failed
  factory LoginState.failure() {
    return LoginState(
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

 factory LoginState.error(String error) {
    return LoginState(
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      error: error
    );
  }
  //*The state of the form when a login attempt has succeeded
  factory LoginState.success() {
    return LoginState(
      isPhoneValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  LoginState update({
    bool isPhoneValid,
    bool isSuccess
  }) {
    return copyWith(
      isPhoneValid: isPhoneValid,
      isSubmitting: false,
      isSuccess: isSuccess,
      isFailure: false,
    );
  }

  LoginState copyWith({
    bool isPhoneValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return LoginState(
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

    @override
  String toString() {
    return '''LoginState {
      isPhoneValid: $isPhoneValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}

