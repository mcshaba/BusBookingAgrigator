import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:safejourney/apis/safe_journey_api.dart';
import 'package:safejourney/bloc/bloc/booking_status_bloc.dart';
import 'package:safejourney/bloc/bloc/booking_status_event.dart';
import 'package:safejourney/bloc/states_search/bloc/bloc.dart';
import 'package:safejourney/bloc/trip_search/bloc/bloc.dart';
import 'package:safejourney/bloc/trip_search/bloc/tripsearch_bloc.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/main.dart';
import 'package:safejourney/model/state.dart';
import 'package:safejourney/navigation/router_arguments.dart';
import 'package:safejourney/repository/state_repository.dart';
import 'package:safejourney/themes/styles.dart';
import 'package:safejourney/widgets/ticket_card_widget.dart';
import 'package:safejourney/widgets/ticket_widget.dart';
import 'package:safejourney/widgets/top_places_widget.dart';

final Color discountBackgroundColor = Color(0xFFFFE08D);
final Color flightBorderColor = Color(0xFFE6E6E6);
final Color chipBackgroundColor = Color(0xFFF6F6F6);

class BookingStatusView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Booking Status",
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
      body: BlocProvider<BookingStatusBloc>(
        builder: (context) => BookingStatusBloc(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              _StatusSearch(),
              //FlightListingBottomPart(),
            ],
          ),
        ),),
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
                        Navigator.pushReplacementNamed(
                            context, StateSearchRoute);
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
                          Navigator.pushReplacementNamed(
                              context, StateSearchRoute);
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

class _StatusSearch extends StatefulWidget {
  @override
  _StatusSearchState createState() => _StatusSearchState();
}

class _StatusSearchState extends State<_StatusSearch> {
  TextEditingController _statusController = TextEditingController();
  BookingStatusBloc _stateSearchBloc;

  @override
  void initState() {
    super.initState();
    _stateSearchBloc = BlocProvider.of<BookingStatusBloc>(context);
  }

  @override
  void dispose() {
    _statusController.dispose();
    _stateSearchBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildStatusWidget(context),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                buildStatusCheckButton(context),
                SizedBox(
                  width: 16,
                ),
                SizedBox(
                  width: 8,
                ),
                // buildAdultCounter(),
              ],
            ),
          ],
        ),
      ),
    );
    
  }

  Widget buildStatusCheckButton(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.blueGrey),
      onPressed: () async {
        var status = _statusController.text;

        //        _stateSearchBloc.dispatch(StatusClickEvent(bookRef: status));

        Navigator.of(context).pushNamed(BookingStatusResult, arguments: status);
//        final stateBloc = BlocProvider.of<BookingStatusBloc>(context);
//        stateBloc.dispatch(StatusClickEvent(bookRef: status));
      },
      child: Text(
        'Check Status',
        style: TextStyle(color: Colors.blueGrey[800]),
      ),
    );
  }

  Widget _buildStatusWidget(context) {
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
          controller: _statusController,
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
            hintText: "E.g: SFT-123456",
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
              onTap: _onClearTapped,
            ),
          ),
          maxLines: 1,
          onChanged: (text) {
          },
          // controller: _searchControl,
        ),
      ),
    );
  }

  void _onClearTapped() {
    _statusController.text = '';
    _stateSearchBloc.dispatch(StatusClickEvent(bookRef: ''));
  }

}


