import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GeolocationState extends Equatable {
  GeolocationState([List props = const []]) : super(props);
}

class GeoLocationStateEmpty extends GeolocationState {
  @override
  String toString() => 'GeoLocationStateEmpty';
}

class GeoLocationStateLoading extends GeolocationState {
  @override
  String toString() => 'GeoLocationStateLoading';
}

class GeoLocationSuccess extends GeolocationState {
  final String address;

  GeoLocationSuccess(this.address): super([address]);

  @override
  String toString() => 'GeoLocationSuccess { address: $address }';
}

class GeoLocationStateError extends GeolocationState {
  @override
  String toString() => 'GeoLocationStateError';
}