import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safejourney/apis/safe_journey_api.dart';
import 'package:safejourney/repository/trip_repository.dart';
import './bloc.dart';

class TripsearchBloc extends Bloc<TripsearchEvent, TripsearchState> {
  TripRepository _tripRepository;

  TripsearchBloc({TripRepository tripRepository,
  }) : _tripRepository = tripRepository ?? TripRepository.getInstance(SafeJourneyApi());


@override
Stream<TripsearchState> transform(
  Stream<TripsearchEvent> events,
  Stream<TripsearchState> Function(TripsearchEvent event) next,
) {
  return super.transform(
    (events as Observable<TripsearchEvent>).debounceTime(
      Duration(milliseconds: 500),
    ),
    next,
  );
}
  @override
  Stream<TripsearchState> mapEventToState(TripsearchEvent event) async* {
    if (event is TripFetch && !_hasReachedMax(currentState)) {
    try {
      if (currentState is TripSearchUninitialized) {
        final schedules = await _tripRepository.getSearchBuses(event.departureState, event.arrivalState, event.tripDate, event.adultCount);
        yield TripSearchLoaded(schedules: schedules.data, hasReachedMax: false);
        return;
      }
      if (currentState is TripSearchLoaded) {
        // final posts =
        //     await _fetchPosts((currentState as TripSearchLoaded).schedules.length, 20);
        // yield posts.isEmpty
        //     ? (currentState as TripSearchLoaded).copyWith(hasReachedMax: true)
        //     : TripSearchLoaded(
        //         schedules: (currentState as TripSearchLoaded).schedules + schedules,
        //         hasReachedMax: false,
        //       );
      }
    } catch (error) {
      yield TripSearchError(error: error.toString() ?? 'An error has occurred');
    }
  }
  }

bool _hasReachedMax(TripsearchState state) =>
    state is TripSearchLoaded && state.hasReachedMax;

  @override
get initialState => TripSearchUninitialized();


}

