import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safejourney/bloc/authentication_bloc.dart';
import 'package:safejourney/bloc/authentication_event.dart';
import 'package:safejourney/repository/user_repository.dart';
import 'package:safejourney/utilities/validators.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required  this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null);

  @override
  LoginState get initialState => LoginState.empty();

  ///  *We're overriding transform in order to debounce the EmailChanged
  /// *and PasswordChanged events so that we give the user some time to stop typing before validating the input

  // @override
  // Stream<LoginState> transform(
  //   Stream<LoginEvent> events,
  //   Stream<LoginState> Function(LoginEvent event) next,
  // ) {
  //   final observableStream = events as Observable<LoginEvent>;
  //   final nonDebounceStream = observableStream.where((event) {
  //     return (event is! PhoneNumberChanged);
  //   });
  //   final debounceStream = observableStream.where((event) {
  //     return (event is PhoneNumberChanged);
  //   }).debounceTime(Duration(milliseconds: 300));
  //   return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  // }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is PhoneNumberChanged) {
      yield* _mapPhoneChangedToState(event.phoneNumber);
    } else if (event is VerificationCodeChanged) {
      // yield* _mapVerificationCodeChangedToState(event.code);
    } else if (event is LoginWithPhonePressed) {
      yield* _mapLoginWithPhonePressedToState(phone: event.phoneNumber);
    } else if (event is LoginAsGuestPressed) {
      yield* _mapLoginAsGuestPressedToState();
    }
  }

  Stream<LoginState> _mapLoginAsGuestPressedToState() async* {
    yield LoginState.loading();
    try {
      await userRepository.signInAsGuest();
      authenticationBloc.dispatch(LoggedIn());
      yield LoginState.success();
    } catch (error) {
      yield LoginState.error(error.message);
    }
  }

  Stream<LoginState> _mapPhoneChangedToState(String phone) async* {
    yield currentState.update(
      isPhoneValid: Validators.isValidPhone(phone),
    );
  }

  Stream<LoginState> _mapLoginWithPhonePressedToState({String phone}) async* {
    yield LoginState.loading();
    // try {
    //   await userRepository.verifyPhoneNumber(phone);
    //   yield LoginState.success();
    // } catch (error) {
    //   yield LoginState.error(error.toString());
    // }
  }
}
