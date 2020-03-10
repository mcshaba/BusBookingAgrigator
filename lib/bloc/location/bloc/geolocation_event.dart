import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GeolocationEvent extends Equatable {
  GeolocationEvent([List props = const []]) : super(props);
}


class RequestLocationEvent extends GeolocationEvent {
  @override
  String toString() => 'RequestLocationEvent';
}