import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safejourney/apis/safe_journey_api.dart';
import 'package:safejourney/bloc/location/bloc/bloc.dart';
import 'package:safejourney/bloc/states_search/bloc/bloc.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/model/state.dart';
import 'package:safejourney/navigation/router_arguments.dart';
import 'package:safejourney/repository/state_repository.dart';

class StateSearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StatesearchBloc>(
          builder: (context) => StatesearchBloc(
              stateRepository: StateRepository(api: SafeJourneyApi())),
        ),
        BlocProvider<GeolocationBloc>(
          builder: (context) => GeolocationBloc(),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(''),
        ),
        body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SearchBar(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 22),
                    child: _StateSearchBody(),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();
  StatesearchBloc _stateSearchBloc;
  GeolocationBloc _geolocationBloc;

  TextEditingController _pickupController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _stateSearchBloc = BlocProvider.of<StatesearchBloc>(context);
    _geolocationBloc = BlocProvider.of<GeolocationBloc>(context);
    _geolocationBloc.dispatch(RequestLocationEvent());
  }

  @override
  void dispose() {
    _textController.dispose();
    _pickupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            _buildPickupWidget(context),
            BlocListener<GeolocationBloc, GeolocationState>(
              listener: (context, state) {
                if (state is GeoLocationSuccess) {
                  _pickupController.text = state.address;
                } else if (state is GeoLocationStateError) {}
              },
              child: _buildDestinationWidget(context),
            ),
            BlocListener<StatesearchBloc, StatesearchState>(
              listener: (context, state) {
                if(state is StatePickupClickEventLoaded){
                  _pickupController.text = state.stateName;
                }
                if(state is StateClickEventLoaded){
                  _textController.text = state.stateName;

                  Navigator.of(context).pushNamed(TripResultScreenRoute,
                      arguments: TripResultArgument(
                          pickup: _pickupController.text, destination: state.stateName, tripDate:  DateTime.now().toIso8601String()));
                }
              },
              child: Container(width: 0.0,height: 0.0,),
            ),
          ],
        ),
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _stateSearchBloc.dispatch(StateTextChanged(text: ''));
  }

  void _onClearLocationTapped() {
    _pickupController.text = '';
    _stateSearchBloc.dispatch(StatePickupTextChanged(text: ''));
  }

  Widget _buildPickupWidget(context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: TextField(
          onTap: () {
            // FocusScope.of(context).requestFocus(new FocusNode());
            // Navigator.of(context).pushNamed(StateSearchRoute);
          },
          enableInteractiveSelection: false,
          autocorrect: false,
          controller: _pickupController,
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.blueGrey[900],
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "E.g: Lagos, Delta, Abuja",
            prefixIcon: Icon(
              Icons.arrow_upward,
              color: Colors.blueGrey[300],
            ),
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey[300],
            ),
            suffixIcon: GestureDetector(
              child: Icon(Icons.clear),
              onTap: _onClearLocationTapped,
            ),
          ),
          maxLines: 1,
          onChanged: (text) {
            _stateSearchBloc.dispatch(
              StatePickupTextChanged(text: text),
            );
          },
          // controller: _searchControl,
        ),
      ),
    );
  }

  Widget _buildDestinationWidget(context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: TextField(
          controller: _textController,
          autocorrect: false,
          autofocus: true,
          enableInteractiveSelection: false,
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.blueGrey[900],
              fontWeight: FontWeight.w500),

          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "E.g: Lagos, Delta, Abuja",
            prefixIcon: Icon(
              Icons.arrow_downward,
              color: Colors.blueGrey[300],
            ),
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey[300],
            ),
            suffixIcon: GestureDetector(
              child: Icon(Icons.clear),
              onTap: _onClearTapped,
            ),
          ),
          maxLines: 1,
          onChanged: (text) {
            _stateSearchBloc.dispatch(
              StateTextChanged(text: text),
            );
          },
          // controller: _searchControl,
        ),
      ),
    );
  }
}

class _StateSearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatesearchBloc, StatesearchState>(
      bloc: BlocProvider.of<StatesearchBloc>(context),
      builder: (context, state) {
        if (state is SearchStateEmpty) {
          return Text(
            'Please enter a destination to begin',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey[300],
            ),
          );
        }
        if (state is SearchStateLoading) {
          return CircularProgressIndicator();
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return state.items.isEmpty
              ? Text('No Results')
              : _StateSearchResults(items: state.items);
        }
        if (state is SearchPickupStateSuccess) {
          return state.pickItems.isEmpty
              ? Text('No Result')
              : _StatePickupSearchResults(items: state.pickItems);
        }

          return Container();
      },
    );
  }
}

class _StateSearchResults extends StatelessWidget {
  final List<StateModel> items;

  const _StateSearchResults({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.blueGrey[300],
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _StateSearchResultItem(item: items[index]);
      },
    );
  }
}

class _StatePickupSearchResults extends StatelessWidget {
  final List<StateModel> items;

  const _StatePickupSearchResults({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.blueGrey[300],
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _StateSearchPickupResultItem(item: items[index]);
      },
    );
  }
}

class _StateSearchResultItem extends StatelessWidget {
  final StateModel item;

  const _StateSearchResultItem({Key key, @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: Text(item.code),
      // leading: Icon(Icons.arrow_forward),
      trailing: Text(item.capital,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.blueGrey[300],
          )),
      title: Text(item.name),
      onTap: () async {
        final stateBloc = BlocProvider.of<StatesearchBloc>(context);
        stateBloc.dispatch(StateClickEvent(item.name));
      },
    );
  }
}

class _StateSearchPickupResultItem extends StatelessWidget {
  final StateModel item;

  const _StateSearchPickupResultItem({Key key, @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: Text(item.code),
      // leading: Icon(Icons.arrow_forward),
      trailing: Text(item.capital,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.blueGrey[300],
          )),
      title: Text(item.name),
      onTap: () async {
        final stateBloc = BlocProvider.of<StatesearchBloc>(context);
        stateBloc.dispatch(StatePickupClickEvent(item.name));
      },
    );
  }
}
