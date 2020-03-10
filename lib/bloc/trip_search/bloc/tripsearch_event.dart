import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TripsearchEvent extends Equatable {
  TripsearchEvent([List props = const []]) : super(props);
}

class TripFetch extends TripsearchEvent {
  final String departureState;
  final String arrivalState;
  final String tripDate;
  final String adultCount;

  TripFetch({
    @required this.departureState,
    @required this.arrivalState,
    @required this.tripDate,
    @required this.adultCount,
  }) : super([departureState,arrivalState,tripDate,adultCount]);
  @override
  String toString() => 'TripFetch: \n Departure- $departureState \n arrival- $arrivalState \n tripDate: $tripDate';
}
