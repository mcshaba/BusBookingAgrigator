import 'package:cyberpaysdkflutter/ui/flutter_credit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_bloc.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_event.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_state.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/model/booking_form.dart';
import 'package:safejourney/model/search_bus_model.dart';
import 'package:safejourney/screens/cyberpay_view.dart';
import 'package:safejourney/themes/styles.dart';
import 'package:safejourney/utilities/flushbar_helper.dart';
import 'package:safejourney/widgets/line_dash_widget.dart';
import 'package:safejourney/widgets/seat_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:url_launcher/url_launcher.dart';

class BookingScreen extends StatefulWidget {
  final BusSchedule _busSchedule;

  const BookingScreen({Key key, @required BusSchedule busSchedule})
      : assert(busSchedule != null),
        _busSchedule = busSchedule,
        super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  PageController controller;
  BookingformBloc _busBookingBloc;
  String informationText = 'Swipe to the next page >';

  BookingForm bookingForm;

  static const platform = const MethodChannel('com.startActivity/testChannel');

  @override
  void initState() {
    super.initState();
    controller = PageController();
    _busBookingBloc = BookingformBloc(schedule: widget._busSchedule);
    _busBookingBloc.dispatch(BookingFormStarted());
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _busBookingBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "",
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
        builder: (context) => _busBookingBloc,
        child: Container(
          child: PageView(
            onPageChanged: (int page) {
              switch (page) {
                case 1:
                  setState(() {
                    informationText = 'Swipe to confirm booking';
                  });
                  break;
                case 2:
                  setState(() {
                    informationText = '';
                  });
                  break;
                default:
                  informationText = 'Swipe to go to the next page';
                  break;
              }
            },
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              SeatSelectionView(),
              PassengerInfoView(
                busSchedule: widget._busSchedule,
              ),
              PaymentSelectionView(
                busSchedule: widget._busSchedule,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(
                  color: Colors.black12, width: 1, style: BorderStyle.solid)),
        ),
        child: BlocProvider(
          builder: (context) => _busBookingBloc,
          child: BlocListener<BookingformBloc, BookingformState>(
            listener: (context, state) {
              if (state is BookingFormLoading) {}
              if (state is BookingFormSaveFailure) {
                FlushbarHelper.createError(message: "${state.error}")
                    .show(context);
              }

              if (state is BookingFormSaveSuccess) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text(
                          "Booking Successful - Reference ${state.bookingReference}"),
                      content: new Text(
                          "You have successfully placed an order for this trip, and yor order confirmed."),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
//                        new FlatButton(
//                          child: new Text("Pay for trip"),
//                          onPressed: () async {
//                            const url = "${state.redirectUrl}";
//                            if (await canLaunch(url)) {
//                              await launch(url);
//                            } else {
//                              await launch("https://payment.staging.cyberpay.ng/pay?reference=JAG000001190819465096");
//                            }
//                            // Navigator.pushNamed(context, HomeViewRoute);
//                          },
//                        ),
                        new FlatButton(
                          child: new Text("Okay"),
                          onPressed: () {
                            Navigator.pushNamed(context, HomeViewRoute);
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: BlocBuilder<BookingformBloc, BookingformState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),

                        child: buildInstructionText(),
//                         child: RichText(
//                           text: new TextSpan(children: [
//                             new TextSpan(
//                                 text: "N${widget._busSchedule.promoPrice} ",
//                                 style: mediumTextStyle),
//                             new TextSpan(
//                               text: "/ adult",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.blueGrey[400],
//                                 fontWeight: FontWeight.w400,
//                                 fontStyle: FontStyle.normal,
//                               ),
//                             ),
//                           ]),
//                         ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        height: 44,
                        child: _buildTripAmountWidget(state),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInstructionText() {
    return Text(informationText);
  }

  Widget _buildTripAmountWidget(BookingformState state) {
    var ctaText = '';
    if (state is BookingFormUpdated) {
      ctaText =
          'Book - ₦${NumberFormat("###.0#", "en_US").format(state.bookingForm.tripAmount.toInt() ?? 0)}';
    } else {
      ctaText = 'Book - ₦${NumberFormat("###.0#", "en_US").format(0)}';
    }
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: 44,
      child: FlatButton(
        disabledColor: Colors.blueGrey[300],
        // disabledTextColor: Colors.blueGrey[900],
        color: Colors.blueGrey[900],
        onPressed:
            (state.bookingForm != null && state.bookingForm.isFormCompleted())
                ? () async {
                    String response = "";
                    try {
                      final String result = await platform.invokeMethod(
                          'chargeCard', state.bookingForm.toJson());
//                      final String result = await platform
//                          .invokeMethod('chargeCard', <String, dynamic>{
//                        'bookingForm': state.bookingForm.toJson(),
//                        'busSchedule': state.bookingForm.schedule.toJson()
//                      });
                      response = result;
                    } on PlatformException catch (e) {
                      response = "Failed to Invoke: '${e.message}'.";
                    }
                  }
                : null,
        // child:
        child: _buildTripButtonChild(state, ctaText),
      ),
    );
  }

  Widget _buildTripButtonChild(BookingformState state, String text) {
    if (state is BookingFormLoading) {
      return SpinKitThreeBounce(
        color: Colors.white,
        size: 20,
      );
    } else {
      return Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      );
    }
  }

  Future<void> CheckoutPayment(Map<String, dynamic> json) async {
    try {
      final String result = await platform.invokeMethod('chargeCard', json);
      //return result;
      debugPrint('Result: $result ');
    } on PlatformException catch (e) {
      debugPrint("Error: '${e.message}'.");
    }
  }
}

class PaymentSelectionView extends StatelessWidget {
  final BusSchedule _busSchedule;

  const PaymentSelectionView({Key key, @required BusSchedule busSchedule})
      : assert(busSchedule != null),
        _busSchedule = busSchedule,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingformBloc, BookingformState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  "Confirm booking details",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "After confirmation of booking, you can use your booking ID to access all the details of your booking.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[800],
                  ),
                ),
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
                    Text(
                      "${state.bookingForm.schedule.busName}",
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
                      "Booking Date",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Text(
                      "${DateFormat.yMMMd().format(DateTime.now())}",
                      textAlign: TextAlign.end,
                      style: smallBoldTextStyle,
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
                      "Bus Operator",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Text(
                      "${state.bookingForm.schedule.tenantName}",
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
                      "Departing",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        "${state.bookingForm.schedule.departure}",
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
                      "Destination",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        "${state.bookingForm.schedule.destination}",
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
                      "Departure Time",
                      textAlign: TextAlign.start,
                      style: smallTextStyle,
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        "${DateFormat.MMMEd().format(state.bookingForm.schedule.tripdate)}, ${state.bookingForm.schedule.departureTime}",
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
                        "${state.bookingForm.seats.join(', ')}",
                        textAlign: TextAlign.end,
                        style: smallBoldTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: _buildCouponWidget(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCouponWidget(context) {
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
          // controller: _pickupController,
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
            hintText: "Enter coupon code here",
            prefixIcon: Icon(
              EvilIcons.tag,
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
}

class SeatSelectionView extends StatefulWidget {
  const SeatSelectionView({Key key}) : super(key: key);

  @override
  _SeatSelectionViewState createState() => _SeatSelectionViewState();
}

class _SeatSelectionViewState extends State<SeatSelectionView>
    with AutomaticKeepAliveClientMixin<SeatSelectionView> {
  BookingformBloc _busBookingBloc;
  BookingForm bookingForm;

  String CHANNEL = "com.startActivity/testChannel";

  // static const platformChannel = const MethodChannel(CHANNEL);
  static const platform = const MethodChannel('com.startActivity/testChannel');

  @override
  void initState() {
    super.initState();
    _busBookingBloc = BlocProvider.of<BookingformBloc>(context);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<BookingformBloc, BookingformState>(
        listener: (context, state) {
      if (state is BookingFormInital) {
        print('Initial available seats: ${state.bookingForm.availableSeats}');
      }
      if (state is BookingFormUpdated) {
        print('available seats: ${state.bookingForm.availableSeats}');
      }
    }, child: BlocBuilder<BookingformBloc, BookingformState>(
      builder: (context, state) {
        int availableSeats;
        if (state is BookingFormUpdated) {
          availableSeats = state.bookingForm.availableSeats;
        }
        return SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "$availableSeats seats available",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueGrey[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Click on seat to select/deselect",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey[800],
                ),
              ),
            ),
            SeatView(),
          ],
        ));
      },
    ));
  }
}

class PassengerInfoView extends StatefulWidget {
  final BusSchedule _busSchedule;

  //todo: update price of tickets after user has selected seats.
  const PassengerInfoView({Key key, @required BusSchedule busSchedule})
      : assert(busSchedule != null),
        _busSchedule = busSchedule,
        super(key: key);

  @override
  _PassengerInfoViewState createState() => _PassengerInfoViewState();
}

class _PassengerInfoViewState extends State<PassengerInfoView>
    with AutomaticKeepAliveClientMixin<PassengerInfoView> {
  final TextEditingController _passengerNameController =
      TextEditingController();
  final TextEditingController _passengerEmailController =
      TextEditingController();
  final TextEditingController _passengerPhoneController =
      TextEditingController();
  final TextEditingController _kinNameController = TextEditingController();
  final TextEditingController _kinEmailController = TextEditingController();
  final TextEditingController _kinPhoneController = TextEditingController();

  BookingformBloc _busBookingBloc;
  static const platform = const MethodChannel('com.startActivity/testChannel');

  BookingForm bookingForm;

  @override
  void initState() {
    super.initState();
    _busBookingBloc = BlocProvider.of<BookingformBloc>(context);
    _passengerNameController.addListener(_onPassengerNameChanged);
    _passengerEmailController.addListener(_onPassengerEmailChanged);
    _passengerPhoneController.addListener(_onPassengerPhoneChanged);
    _kinNameController.addListener(_onKinNameChanged);
    _kinEmailController.addListener(_onKinEmailChanged);
    _kinPhoneController.addListener(_onKinPhoneChanged);
    // ignore: missing_return
    platform.setMethodCallHandler((call) {
      final String argument = call.arguments;
      switch (call.method) {
        case "onSuccess":
          String payload = '';

          _busBookingBloc.dispatch(BookingButtonPressed(
              _busBookingBloc.bookingForm, argument, payload));
          break;
      }
    });
  }

  void _onPassengerNameChanged() {
    _busBookingBloc.dispatch(
      PassengerNameChange(_passengerNameController.text),
    );
  }

  void _onPassengerEmailChanged() {
    _busBookingBloc.dispatch(
      PassengerEmailChange(_passengerEmailController.text),
    );
  }

  void _onPassengerPhoneChanged() {
    _busBookingBloc.dispatch(
      PassengerPhoneChange(_passengerPhoneController.text),
    );
  }

  void _onKinNameChanged() {
    _busBookingBloc.dispatch(
      KinNameChange(_kinNameController.text),
    );
  }

  void _onKinEmailChanged() {
    _busBookingBloc.dispatch(
      KinEmailChange(_kinEmailController.text),
    );
  }

  void _onKinPhoneChanged() {
    _busBookingBloc.dispatch(
      KinPhoneChange(_kinPhoneController.text),
    );
  }

  @override
  void dispose() {
    _passengerNameController.dispose();
    _passengerEmailController.dispose();
    _passengerPhoneController.dispose();
    _kinNameController.dispose();
    _kinEmailController.dispose();
    _kinPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        child: BlocBuilder<BookingformBloc, BookingformState>(
      builder: (context, state) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  "Passenger Information",
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
                child: Text(
                  "Enter passenger details.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ),
              _buildFullNameWidget(context, state),
              _buildEmailWidget(context, state),
              _buildPhoneNumberWidget(context, state),
              _buildKinFullNameWidget(context, state),
              _buildKinEmailWidget(context, state),
              _buildKinPhoneNumberWidget(context, state),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    ));
  }

  Widget _buildFullNameWidget(context, BookingformState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextFormField(
          autocorrect: false,
          // controller: _pickupController,
          decoration: defaultTextFieldInputDecoration(
              hint: 'Enter your full name', label: 'Full name'),
          maxLines: 1,
          controller: _passengerNameController,
          autovalidate: true,
          validator: (_) {
            return !state.bookingForm.isPassengerNameValid()
                ? 'Please enter your name.'
                : null;
          }
          // controller: _searchControl,
          ),
    );
  }

  Widget _buildEmailWidget(context, BookingformState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextFormField(
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        // controller: _pickupController,
        decoration: defaultTextFieldInputDecoration(
            hint: 'Enter your email address', label: 'Email'),
        maxLines: 1,
        controller: _passengerEmailController,
        autovalidate: true,
        validator: (_) {
          return !state.bookingForm.isPassengerEmailValid()
              ? 'Please enter a valid email address.'
              : null;
        },
        // controller: _searchControl,
      ),
    );
  }

  Widget _buildPhoneNumberWidget(context, BookingformState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextFormField(
        autocorrect: false,
        keyboardType: TextInputType.phone,
        decoration: defaultTextFieldInputDecoration(
            prefix: '+234',
            // hint: 'Enter your phone name',
            label: 'Phone number'),
        maxLines: 1,
        controller: _passengerPhoneController,
        autovalidate: true,
        validator: (_) {
          return !state.bookingForm.isPassengerPhoneValid()
              ? 'Please provide an actual phone number.'
              : null;
        },
        // controller: _searchControl,
      ),
    );
  }

  Widget _buildKinFullNameWidget(context, BookingformState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextFormField(
        autocorrect: false,
        // controller: _pickupController,
        decoration: defaultTextFieldInputDecoration(
            hint: 'Provide your next of kin name', label: 'Kin name'),
        maxLines: 1,
        // controller: _searchControl,
        controller: _kinNameController,
        autovalidate: true,
        validator: (_) {
          return !state.bookingForm.isKinNameValid()
              ? 'Please enter a valid name.'
              : null;
        },
      ),
    );
  }

  Widget _buildKinEmailWidget(context, BookingformState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        child: TextFormField(
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: defaultTextFieldInputDecoration(
              hint: 'Provide your next of kin email address',
              label: 'Kin email'),
          maxLines: 1,
          autovalidate: true,
          controller: _kinEmailController,
          validator: (_) {
            return !state.bookingForm.isKinEmailValid()
                ? 'Please enter a valid email address.'
                : null;
          },
        ),
        // controller: _searchControl,
      ),
    );
  }

  Widget _buildKinPhoneNumberWidget(context, BookingformState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextFormField(
        autocorrect: false,
        keyboardType: TextInputType.phone,
        // controller: _pickupController,
        decoration: defaultTextFieldInputDecoration(
            // hint: ' Next of kin phone number',
            prefix: '+234',
            label: 'Kin phone'),
        maxLines: 1,
        controller: _kinPhoneController,
        autovalidate: true,
        validator: (_) {
          return !state.bookingForm.isKinPhoneValid()
              ? 'Please provide an actual phone number.'
              : null;
        },
        // controller: _searchControl,
      ),
    );
  }

  InputDecoration defaultTextFieldInputDecoration(
      {String hint, String prefix, String label}) {
    return InputDecoration(
      border: new OutlineInputBorder(
          borderSide:
              new BorderSide(color: const Color(0xFFE0E0E0), width: 0.1)),
      hintText: hint,
      labelText: label,
      prefixText: prefix,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
