import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PhoneverificationEvent extends Equatable {
  PhoneverificationEvent([List props = const []]) : super(props);
}

class ChangeNumberEvent extends PhoneverificationEvent{
  
}
class PhoneNextButtonPressedEvent extends PhoneverificationEvent {

}

class CodeVerifyButtonPressedEvent extends PhoneverificationEvent {

} 

class PhoneSentSuccessEvent extends PhoneverificationEvent {

} 

class CodeVerifySuccessEvent extends PhoneverificationEvent {

} 

class CodeVerificationFailureEvent extends PhoneverificationEvent {
   final String error;

  CodeVerificationFailureEvent({@required this.error}) : super([error]);

  @override
  String toString() => 'CodeVerificationFailureEvent { error: $error }';
}

class PhoneSentFailureEvent extends PhoneverificationEvent {
   final String error;

  PhoneSentFailureEvent({@required this.error}) : super([error]);

  @override
  String toString() => 'PhoneSentFailureEvent { error: $error }';
}