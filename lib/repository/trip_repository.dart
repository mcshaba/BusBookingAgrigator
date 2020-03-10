import 'package:safejourney/apis/safe_journey_api.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/model/search_bus_model.dart';
import 'package:safejourney/model/state_terminal_response.dart';
import 'package:safejourney/repository/state_repository.dart';

class TripRepository {
  static SafeJourneyApi _api;
  static TripRepository _instance;

  static TripRepository getInstance(SafeJourneyApi api) {
    if (_instance == null) {
      _api = api ?? SafeJourneyApi();
      _instance = TripRepository();
    }
    return _instance;
  }

  Future<SearchBusResponse> getSearchBuses(String fromState, String toState,
      String tripDate, String noofAdults) async {
    String departure;
    String arrival;

    if (fromState.toLowerCase() == AnywhereLocation.toLowerCase()) {
      departure = ''; //* Departure location to everywhere
    } else {
      var from = await StateRepository(api: _api).search(fromState);
      assert(from != null);
      departure = from.first.code;
    }

    if (toState.toLowerCase() == AnywhereLocation.toLowerCase()) {
      arrival = ''; //* Anywhere to arrival location
    } else {
      var to = await StateRepository(api: _api).search(toState);
      assert(to != null);
      arrival = to.first.code;
    }

    try {
      if (departure.isEmpty) {
        return _api.getAnywhereToStateBuses(
            arrival, DateTime.parse(tripDate), int.parse(noofAdults));
      }
      if (arrival.isEmpty) {
        return _api.getStateToEveryWhereBuses(
            departure, DateTime.parse(tripDate), int.parse(noofAdults));
      }

      return _api.getSearchBus(
          departure, arrival, DateTime.parse(tripDate), int.parse(noofAdults));
    } catch (error) {
      rethrow;
    }
  }

  Future<StateTerminalResponse> getBusesTerminalByState(String text) async {
    try {
      return _api.getBusesTerminalByState(text);
    } catch (error) {
      rethrow;
    }
  }
}
