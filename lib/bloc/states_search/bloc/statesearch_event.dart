import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StatesearchEvent extends Equatable {
  StatesearchEvent([List props = const []]) : super(props);
}

class StateTextChanged extends StatesearchEvent {
  final String text;

  StateTextChanged({this.text}) : super([text]);

  @override
  String toString() => 'TextDestinationChanged { text: $text }';
}


class StatePickupTextChanged extends StatesearchEvent {
  final String text;

  StatePickupTextChanged({this.text}) : super([text]);

  @override
  String toString() => 'TextPickUpChanged { text: $text }';
}

class StatePickupClickEvent extends StatesearchEvent {
  final String stateName;

  StatePickupClickEvent(this.stateName) : super([stateName]);
  @override
  String toString() => 'StatePickupClickEvent { name: $stateName}';
}

class StateClickEvent extends StatesearchEvent {
  final String stateName;

  StateClickEvent(this.stateName) : super([stateName]);
  @override
  String toString() => 'RequestStateClickEvent { name: $stateName}';
}