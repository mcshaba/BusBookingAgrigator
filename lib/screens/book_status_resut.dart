import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:safejourney/bloc/bloc/booking_status_bloc.dart';
import 'package:safejourney/bloc/bloc/booking_status_event.dart';
import 'package:safejourney/bloc/bloc/booking_status_state.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_bloc.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_state.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/model/booking_status_response.dart';
import 'package:safejourney/model/search_bus_model.dart';
import 'package:safejourney/themes/styles.dart';
import 'package:safejourney/widgets/line_dash_widget.dart';
import 'package:safejourney/widgets/top_places_widget.dart';

final Color discountBackgroundColor = Color(0xFFFFE08D);
final Color flightBorderColor = Color(0xFFE6E6E6);
final Color chipBackgroundColor = Color(0xFFF6F6F6);

class BookingStatusResultView extends StatefulWidget {
  final String _referenceArgument;
  const BookingStatusResultView({Key key, @required String bookingReference})
      : assert(bookingReference != null),
        _referenceArgument = bookingReference,
        super(key: key);
  @override
  _BookingStatusResultState createState() => _BookingStatusResultState();
}

class _BookingStatusResultState extends State<BookingStatusResultView> {

  String reference;
  @override
  void initState() {
    super.initState();
    reference = widget._referenceArgument;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Booking Result",
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
        builder: (context) => BookingStatusBloc()
          ..dispatch(StatusClickEvent(bookRef: widget._referenceArgument)),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FlightListingBottomPart(),
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
  BookingStatusBloc _tripsearchBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tripsearchBloc = BlocProvider.of<BookingStatusBloc>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingStatusBloc, BookingStatusState>(
        builder: (context, state) {
          if (state is InitialBookingStatusState) {
            return Center(
              child: Image(
                image: new AssetImage("images/loader2.gif"),
                height: 200,
              ),
            );
          }
          if (state is BookingStatusFailure) {
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
                        Navigator.pop(context);
//                        Navigator.pushReplacementNamed(context, StateSearchRoute);
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
          if (state is BookingStatusSuccess) {
            if (state.bookingStatusResponse.recordsFound == 0 || state.bookingStatusResponse.data == null) {
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
                          Navigator.pop(context);
                          //Navigator.pushReplacementNamed(context, StateSearchRoute);
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
              child: PaymentSelectionView(bookingStatusResponse: state.bookingStatusResponse,),
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
class PaymentSelectionView extends StatelessWidget {
  final BookingStatusResponse _bookingStatusResponse;

  const PaymentSelectionView({Key key, @required BookingStatusResponse bookingStatusResponse})
      : assert(bookingStatusResponse != null),
        _bookingStatusResponse = bookingStatusResponse,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingStatusBloc, BookingStatusState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  "Booking Details",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Booking Ref",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Text(
                      "${_bookingStatusResponse.data.bookingRef}",
                      textAlign: TextAlign.end,
                      style: smallBoldTextStyle,
                    ),
                  ],
                ),
              ),

               Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Amount",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Text(
                      "${_bookingStatusResponse.data.amount}",
                      textAlign: TextAlign.end,
                      style: smallBoldTextStyle,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Departure Date",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Text( _bookingStatusResponse.data.tripDate == null ? " -- -- " :
                      "${DateFormat.yMMMd().format(DateTime.parse(_bookingStatusResponse.data.tripDate))}",
                      textAlign: TextAlign.end,
                      style: smallBoldTextStyle,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Departure Time",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        "${_bookingStatusResponse.data.departureTime}",
                        textAlign: TextAlign.end,
                        style: smallBoldTextStyle,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Seat Number",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        "${_bookingStatusResponse.data.seatNumber}",
                        textAlign: TextAlign.end,
                        style: smallBoldTextStyle,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 40,
              ),
              Container(
                // height: 0.5,
                // color: Colors.white,
                padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                child: const LineDashedPainter(color: Colors.blueGrey),
              ),
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Bus",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        "${_bookingStatusResponse.data.tenantName}",
                        textAlign: TextAlign.end,
                        style: smallBoldTextStyle,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Customer Name",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Text(
                      "${_bookingStatusResponse.data.customerName}",
                      textAlign: TextAlign.end,
                      style: smallBoldTextStyle,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Phone No",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        "${_bookingStatusResponse.data.phoneNo}",
                        textAlign: TextAlign.end,
                        style: smallBoldTextStyle,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Booking Date",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Text(
                      "${DateFormat.yMMMMd().format(_bookingStatusResponse.data.bookingDate)}",
                      textAlign: TextAlign.end,
                      style: smallBoldTextStyle,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Payment Method",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        "${_bookingStatusResponse.data.paymentMethod}",
                        textAlign: TextAlign.end,
                        style: smallBoldTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

