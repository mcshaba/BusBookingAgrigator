import 'package:safejourney/model/state.dart';

class StateSearchCache {
  final _cache = <String, StateResponse>{};

  // State get(String term) => _cache[term];

  // void set(String term, State result) => _cache[term] = result;

  bool contains(String term) => _cache.containsKey(term);

  void remove(String term) => _cache.remove(term);
}