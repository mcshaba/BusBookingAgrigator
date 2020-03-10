import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safejourney/model/state.dart';
import 'package:safejourney/repository/state_repository.dart';
import './bloc.dart';

class StatesearchBloc extends Bloc<StatesearchEvent, StatesearchState> {
  final StateRepository stateRepository;

  StatesearchBloc({@required this.stateRepository});

  @override
  Stream<StatesearchState> transform(Stream<StatesearchEvent> events,
      Stream<StatesearchState> Function(StatesearchEvent event) next) {
    return super.transform(
      (events as Observable<StatesearchEvent>).debounceTime(
        Duration(milliseconds: 1000),
      ),
      next,
    );
  }
  @override
  void onTransition(
      Transition<StatesearchEvent, StatesearchState> transition) {
    print(transition);
  }

  @override
  StatesearchState get initialState => SearchStateEmpty();


  @override
  Stream<StatesearchState> mapEventToState(
    StatesearchEvent event,
  ) async* {
    if (event is StateTextChanged) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();
        try {
          final results = await stateRepository.search(searchTerm);
          yield SearchStateSuccess(results);
        } catch (error) {
          print(error);
          yield  SearchStateError('something went wrong');
        }
      }
    } else if (event is StatePickupTextChanged){
      final String searchTerm = event.text;
      if(searchTerm.isEmpty){
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();
        try{
          final results = await stateRepository.search(searchTerm);
          yield SearchPickupStateSuccess(results);
        } catch (error){
          yield SearchStateError('Something went wrong');
        }
      }
    } else if( event is StateClickEvent) {

      yield StateClickEventLoaded(event.stateName);

    }else if( event is StatePickupClickEvent) {

      yield StatePickupClickEventLoaded(event.stateName);

    }
  }

}
