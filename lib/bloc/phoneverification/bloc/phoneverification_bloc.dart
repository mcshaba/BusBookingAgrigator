import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:safejourney/bloc/authentication_bloc.dart';
import 'package:safejourney/bloc/authentication_event.dart';
import './bloc.dart';

class PhoneverificationBloc
    extends Bloc<PhoneverificationEvent, PhoneverificationState> {
  final AuthenticationBloc authenticationBloc;

  PhoneverificationBloc({
    @required this.authenticationBloc,
  }) : assert(authenticationBloc != null);

  @override
  PhoneverificationState get initialState => InitialPhoneverificationState();

  @override
  Stream<PhoneverificationState> mapEventToState(
    PhoneverificationEvent event,
  ) async* {
    if (event is PhoneNextButtonPressedEvent) {
      yield PhoneVerificationLoading();
      new Future.delayed(const Duration(seconds: 3)); //recommend
      yield InitialCodeverificationState();
    } else if (event is CodeVerifyButtonPressedEvent) {
      yield CodeVerificationLoading();
      new Future.delayed(const Duration(
          seconds: 5)); //* 5 seconds to match with timeout of auto check code
    } else if (event is PhoneSentSuccessEvent) {
      yield PhoneVerificationSuccess();
    } else if (event is CodeVerifySuccessEvent) {
      authenticationBloc.dispatch(LoggedIn());
      yield CodeVerificationSuccess();
    }
    else if (event is ChangeNumberEvent){
      yield InitialPhoneverificationState();
    }
  }
}
