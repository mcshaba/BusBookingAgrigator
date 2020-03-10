import 'dart:async' show Completer, Future;
import 'dart:convert';

import 'package:safejourney/apis/safe_journey_api.dart';
import 'package:safejourney/model/book_transaction.dart';
import 'package:safejourney/model/booking_status_response.dart';
import 'package:safejourney/model/state.dart';
import 'package:safejourney/model/state_search_cache.dart';
import 'package:safejourney/model/top_destination.dart';

class StateRepository {
  final SafeJourneyApi _api;
  // final StateSearchCache cache;

  //StateRepository(this._api); // using dependency injection
  StateRepository({SafeJourneyApi api}) : _api = api ?? StateRepository();

  Future<StateResponse> loadState() async {
    String jsonString = await _api.loadStateFromAsset();
    final jsonResponse = json.decode(jsonString);

    return StateResponse.fromJson(jsonResponse);
    // StateResponse states = StateResponse.fromJson(jsonResponse);
    // for (var state in states.data) {
    //   print(state.name + " " + state.code);
    // }
  }

  Future<List<TopDestination>> getTopDestination() async {
    try {
      return _api.getTopStateRoute();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<StateModel>> search(String term) async {
    StateResponse states = await loadState();
    var completer = new Completer<List<StateModel>>();

    var result =
        states.data.where((state) => state.name.toLowerCase().startsWith(term.toLowerCase()) || state.capital.toLowerCase().startsWith(term.toLowerCase()));

    completer.complete(result.toList());

    return completer.future;

    //   if (cache.contains(term)) {
    //     return cache.get(term);
    //   } else {
    //     final result = await loadState().then((result){

    //     });
    //     cache.set(term, result);
    //     return result;
    //   }
    // }
  }
}
