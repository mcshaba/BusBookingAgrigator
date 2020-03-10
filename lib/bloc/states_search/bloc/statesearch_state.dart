import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:safejourney/model/booking_status_response.dart';
import 'package:safejourney/model/state.dart';

@immutable
abstract class StatesearchState extends Equatable {
  StatesearchState([List props = const []]) : super(props);
}

//* will tell the presentation layer that no input has been given by the user
class SearchStateEmpty extends StatesearchState {
  @override
  String toString() => 'SearchStateEmpty';
}

//* will tell the presentation layer it has to display some sort of loading indicator
class SearchStateLoading extends StatesearchState {
  @override
  String toString() => 'SearchStateLoading';
}

//* will tell the presentation layer that it has data to present
class SearchStateSuccess extends StatesearchState {
  final List<StateModel> items;

  SearchStateSuccess(this.items) : super([items]);

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchPickupStateSuccess extends StatesearchState {
  final List<StateModel> pickItems;

  SearchPickupStateSuccess(this.pickItems) : super([pickItems]);

  @override
  String toString() => 'SearchPickupStateSuccess { items: ${pickItems.length} }';
}
//*will tell the presentation layer that an error has occurred while fetching repositories
class SearchStateError extends StatesearchState {
  final String error;

  SearchStateError(this.error) : super([error]);

  @override
  String toString() => 'SearchStateError';
}

class StatePickupClickEventLoaded extends StatesearchState {
  final String stateName;

  StatePickupClickEventLoaded(this.stateName) :super([stateName]);
}

class StateClickEventLoaded extends StatesearchState {
  final String stateName;

  StateClickEventLoaded(this.stateName) :super([stateName]);
}