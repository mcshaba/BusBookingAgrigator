import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BookingStatusEvent extends Equatable {
  BookingStatusEvent([List props = const <dynamic>[]]) : super(props);
}

class StatusClickEvent extends BookingStatusEvent {
  final String bookRef;

  StatusClickEvent({this.bookRef}) : super([bookRef]);

  @override
  String toString() => 'StatusChanged {text: $bookRef}';
}


