import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:safejourney/repository/state_repository.dart';
import './bloc.dart';

class TopDestinationBloc extends Bloc<TopDestinationEvent, TopDestinationState> {

  //  final StateRepository repository = StateModule.container.resolve<StateRepository>();
  final StateRepository repository;

  TopDestinationBloc({@required this.repository}) ;

  void loadTopDestinations(){
    dispatch(LoadTopDestinationEvent());

  }
  
  @override
  TopDestinationState get initialState => InitialTopDestinationState();

  @override
  Stream<TopDestinationState> mapEventToState(
    TopDestinationEvent event,
  ) async* {
    if(event is LoadTopDestinationEvent){
      yield TopDestinationLoading();

      try{
      final topDestination = await repository.getTopDestination();
      yield TopDestinationLoaded(topDestination);
      } catch(error){
        yield TopDestinationError("Something went wrong");
      }
    }
  }
}
