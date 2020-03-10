import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:safejourney/model/search_bus_model.dart';

@immutable
abstract class TripsearchState extends Equatable {
  TripsearchState([List props = const []]) : super(props);
}

class TripSearchUninitialized extends TripsearchState {
  @override
  String toString() => 'TripSearchUninitialized';
}

class TripSearchError extends TripsearchState {
  final String error;
  TripSearchError({
    this.error,
  }) : super([error]);
  @override
  String toString() => 'TripSearchError: $error';
}

class TripSearchLoaded extends TripsearchState {
  final List<BusSchedule> schedules;
  final bool hasReachedMax;

  TripSearchLoaded({
    this.schedules,
    this.hasReachedMax,
  }) : super([schedules, hasReachedMax]);

  TripSearchLoaded copyWith({
    List<BusSchedule> schedules,
    bool hasReachedMax,
  }) {
    return TripSearchLoaded(
      schedules: schedules ?? this.schedules,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'TripSearchLoaded { posts: ${schedules.length}, hasReachedMax: $hasReachedMax }';
}
