import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:safejourney/bloc/trip_search/bloc/bloc.dart';
import 'package:safejourney/bloc/trip_search/bloc/tripsearch_bloc.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/main.dart';
import 'package:safejourney/model/state.dart';
import 'package:safejourney/navigation/router_arguments.dart';
import 'package:safejourney/themes/styles.dart';
import 'package:safejourney/widgets/ticket_card_widget.dart';
import 'package:safejourney/widgets/ticket_widget.dart';
import 'package:safejourney/widgets/top_places_widget.dart';

final Color discountBackgroundColor = Color(0xFFFFE08D);
final Color flightBorderColor = Color(0xFFE6E6E6);
final Color chipBackgroundColor = Color(0xFFF6F6F6);

class TripResultScreen extends StatefulWidget {
  final TripResultArgument _tripResultArgument;
  const TripResultScreen({Key key, @required TripResultArgument tripArguments})
      : assert(tripArguments != null),
        _tripResultArgument = tripArguments,
        super(key: key);
  @override
  _TripResultScreenState createState() => _TripResultScreenState();
}

class _TripResultScreenState extends State<TripResultScreen> {
  TextEditingController _pickupController = TextEditingController();

  TextEditingController _destinationController = TextEditingController();

  int _numberOfAdults = 1;
  String _departureState;
  String _arrivalState;
  DateTime _bookingDate;
  DateTime _initialDate;
  String formattedDate;
  @override
  void initState() {
    super.initState();
    _pickupController.text = widget._tripResultArgument.pickup;
    _destinationController.text = widget._tripResultArgument.destination;
    _departureState = widget._tripResultArgument.pickup;
    _arrivalState = widget._tripResultArgument.destination;
    _initialDate = DateTime.now();
    _bookingDate = DateTime.parse(widget._tripResultArgument.tripDate);
    formattedDate = DateFormat.yMMMMd().format(_bookingDate);
  }

  @override
  void dispose() {
    super.dispose();
    _pickupController.dispose();
    _destinationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Search Result",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          centerTitle: true,
          leading: InkWell(
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocProvider(
          builder: (context) => TripsearchBloc()
            ..dispatch(TripFetch(
              departureState: _departureState,
              arrivalState: _arrivalState,
              adultCount: _numberOfAdults.toString(),
              tripDate: _bookingDate.toIso8601String(),
            )),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildPickupWidget(context),
                        _buildDestinationWidget(context),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
//                            buildFilterButton(context),
//                            SizedBox(
//                              width: 16,
//                            ),
                            buildDatesButton(context),
                            SizedBox(
                              width: 8,
                            ),
                            // buildAdultCounter(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                FlightListingBottomPart(),
              ],
          ),
        ),
      ),
    );
  }

  void addAdults() {
    setState(() {
      _numberOfAdults++;
    });
  }

  void minusAdults() {
    setState(() {
      if (_numberOfAdults != 1) _numberOfAdults--;
    });
  }

  Widget buildAdultCounter() {
    return Container(
      child: new Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.remove,
                color: Colors.red,
              ),
              onPressed: minusAdults,
            ),
            Text('$_numberOfAdults Adult', style: smallTextStyle),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.green,
              ),
              onPressed: addAdults,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterButton(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.blueGrey),
      onPressed: () {},
      child: Text(
        'Filter',
        style: TextStyle(color: Colors.blueGrey[800]),
      ),
    );
  }

  Widget buildDatesButton(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.blueGrey),
      onPressed: () async{
        DateTime picked = await showDatePicker(
            context: context,
            initialDate: _initialDate,
            firstDate: _initialDate,
            lastDate: DateTime(DateTime.now().year+ 2));
        if(picked != null) {
          formattedDate = DateFormat.yMMMMd().format(picked);//DateFormat.MMMEd().format(picked);
          setState(() {
            formattedDate;

            Navigator.of(context).pushNamed(TripResultScreenRoute,
                arguments: TripResultArgument(
                    pickup: _departureState, destination: _arrivalState, tripDate:  picked.toIso8601String()));
//            TripsearchBloc()..dispatch(TripFetch(
//              departureState: _departureState,
//              arrivalState: _arrivalState,
//              adultCount: _numberOfAdults.toString(),
//              tripDate: picked.toIso8601String(),
//            ));
          });
        }
      },
      child: Text(
          formattedDate,
          style: TextStyle(color: Colors.blueGrey[800]),
      ),
    );
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
            FocusScope.of(context).requestFocus(new FocusNode());
            Navigator.of(context).pushNamed(StateSearchRoute);
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
          ),
          maxLines: 1,
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
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            Navigator.of(context).pushNamed(StateSearchRoute);
          },
          controller: _destinationController,
          autocorrect: false,
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
              onTap: () {},
            ),
          ),
          maxLines: 1,
          onChanged: (text) {
            // _stateSearchBloc.dispatch(
            //   StateTextChanged(text: text),
            // );
          },
          // controller: _searchControl,
        ),
      ),
    );
  }
}

class FlightListingBottomPart extends StatefulWidget {
  @override
  FlightListingBottomPartState createState() {
    return new FlightListingBottomPartState();
  }
}

class FlightListingBottomPartState extends State<FlightListingBottomPart> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  TripsearchBloc _tripsearchBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tripsearchBloc = BlocProvider.of<TripsearchBloc>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tripsearchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripsearchBloc, TripsearchState>(
        builder: (context, state) {
      if (state is TripSearchUninitialized) {
        return Center(
          child: Image(
            image: new AssetImage("images/loader2.gif"),
            height: 200,
          ),
        );
      }
      if (state is TripSearchError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image(
                image: new AssetImage("images/error.gif"),
                height: 200,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.error.toString(),
                    style: smallTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                height: 44,
                width: 200,
                child: FlatButton(
                  color: Colors.blueGrey,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, StateSearchRoute);
                  },
                  child: Text(
                    'Try another search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TopPlacesWidget(),
            ],
          ),
        );
      }
      if (state is TripSearchLoaded) {
        if (state.schedules.isEmpty) {
            return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image(
                image: new AssetImage("images/empty.gif"),
                height: 200,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Sorry, we could not find trips related to your search',
                    style: smallTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                height: 44,
                width: 200,
                child: FlatButton(
                  color: Colors.blueGrey,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, StateSearchRoute);
                  },
                  child: Text(
                    'Try another search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TopPlacesWidget(),
            ],
          ),
        );
        }

        return Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Best Deals for Next 6 Months",
                    // style: dropDownMenuItemStyle,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.schedules.length,
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      // return FlightCard(flightDetails: flights[index]);
                      return Container(
                        height: 290,
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 20.0),
                        child: Container(
                          height: 300,
                          width: double.infinity,
//            elevation: 0,
                          child: TicketCardWidget(
                            ticket: state.schedules[index],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      // _postBloc.dispatch(Fetch());
    }
  }
}
