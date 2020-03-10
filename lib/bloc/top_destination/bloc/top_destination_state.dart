import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:safejourney/model/top_destination.dart';

@immutable
abstract class TopDestinationState extends Equatable {
   TopDestinationState([List props = const []]) : super(props);
}

class InitialTopDestinationState extends TopDestinationState {
  @override
  String toString() => 'InitialTopDestination';
}

class TopDestinationLoading extends TopDestinationState{}


class TopDestinationLoaded extends TopDestinationState{
   final List<TopDestination> topDestination;

  TopDestinationLoaded(this.topDestination) : super([topDestination]);

  @override
  String toString() => 'TopDestination Loaded';

}

class TopDestinationError extends TopDestinationState {
  final String error;

  TopDestinationError(this.error) : super([error]);

  @override
  String toString() => 'TopDestinationError $error';
}
