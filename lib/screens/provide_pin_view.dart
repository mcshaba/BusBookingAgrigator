import 'dart:math';

import 'package:cyberpaysdkflutter/src/apis/CyberPayApi.dart';
import 'package:cyberpaysdkflutter/src/models/OtpRequestModel.dart';
import 'package:cyberpaysdkflutter/src/models/TransactionModel.dart';
import 'package:cyberpaysdkflutter/src/models/otp_model.dart';
import 'package:cyberpaysdkflutter/src/repository/TransactionRepository.dart';
import 'package:cyberpaysdkflutter/src/ui/otp_form.dart';
import 'package:cyberpaysdkflutter/src/ui/otp_widget.dart';
import 'package:cyberpaysdkflutter/src/utils/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_bloc.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_event.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_state.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/model/booking_form.dart';
import 'package:safejourney/model/search_bus_model.dart';
import 'package:safejourney/screens/otp_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_view.dart';

class ProvidePinScreen extends StatefulWidget {
  final CardModel transactionModel;

  final BusSchedule _busSchedule;
  final BookingForm _bookingForm;
  final String _payload;

  const ProvidePinScreen(
      {Key key,
        @required BusSchedule busSchedule,
        @required BookingForm bookingForm,
        @required String payload,
        @required CardModel transactionModel})
      : assert(busSchedule != null),
        assert(transactionModel != null),
        _busSchedule = busSchedule,
        _bookingForm = bookingForm,
        transactionModel = transactionModel,
        _payload = payload,
        super(key: key);

  @override
  _ProvidePinScreenScreenState createState() => _ProvidePinScreenScreenState();
}

class _ProvidePinScreenScreenState extends State<ProvidePinScreen> {
  BookingformBloc _busBookingBloc;
  bool isSubmitLoading = false;

  String cardPinNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        builder: (context) => _busBookingBloc,
        child: BlocListener<BookingformBloc, BookingformState>(
          listener: (context, state){
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
                        "You have successfully placed an order for this trip, and your order confirmed."),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
//                      new FlatButton(
//                        child: new Text("Pay for trip"),
//                        onPressed: () async {
////                            const url = "${state.redirectUrl}";
////                            if (await canLaunch(url)) {
////                              await launch(url);
////                            } else {
////                              await launch("https://payment.staging.cyberpay.ng/pay?reference=JAG000001190819465096");
////                            }
//                          // Navigator.pushNamed(context, HomeViewRoute);
//                        },
//                      ),
                      new FlatButton(
                        child: new Text("Okay"),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: ( BuildContext context) => HomeView()
                          ), ModalRoute.withName('/'));

                          //Navigator.pushReplacementNamed(context, HomeViewRoute);
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: <Widget>[
                OtpWidget(
                  otpNumber: cardPinNumber.trim(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: OtpForm(onOtpModelChange: onOtpModelChange),
                  ),
                ),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSubmitButton(){
    if (isSubmitLoading) {
      return RaisedButton(
        color: Colors.blueGrey[900],
        onPressed: () {},
        child: SpinKitThreeBounce(
          color: Colors.white,
          size: 20.0,
        ),
      );
    } else {
      return RaisedButton(
          color: Colors.blueGrey[900],
          child: Text(
            "Verify Pin",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            setState(() {
              isSubmitLoading = true;
            });

            CardModel _cardModel = CardModel(
                name: widget.transactionModel.name,
                cardNumber:
                widget.transactionModel.cardNumber.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
                expiryMonth: (widget.transactionModel.expiryMonth),
                expiryYear: widget.transactionModel.expiryYear,
                cvv: widget.transactionModel.cvv,
                cardPin: cardPinNumber,
                reference: widget.transactionModel.reference
            );

            String payload = '';
            TransactionRepository.getInstance(CyberPayApi())
                .getEncodedPayload(cardModelToJson(_cardModel))
                .then((payloadResult) {
              payload = payloadResult;
            });

            TransactionRepository.getInstance(CyberPayApi())
                .chargeCardApi(
                encodedBody: cardModelToJson(_cardModel),
                success: (success, message) {
                  var loadingBar =
                  FlushbarHelper.createLoading(
                      message:
                      "Transaction successful: Transaction Ref: {$success}, {$message}",
                      linearProgressIndicator:
                      null);
                  loadingBar..show(context);

                  _busBookingBloc.dispatch(BookingButtonPressed(
                      widget._bookingForm, success, payload));
                },
                otpRequired: (charge, card) {
                  setState(() {
                    isSubmitLoading = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new HomeScreen(
                            busSchedule: widget._busSchedule,
                            bookingForm: widget._bookingForm,
                            transactionModel: _cardModel,
                            payload: payload)),
                  );
                },
                providePin: (providePin) {

                  var loadingBar =
                  FlushbarHelper.createLoading(
                      message:
                      "Transaction successful: Transaction Ref: {$providePin}",
                      linearProgressIndicator:
                      null);
                  loadingBar..show(context);

                  setState(() {
                    isSubmitLoading = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new ProvidePinScreen(
                            busSchedule: widget._busSchedule,
                            bookingForm: widget._bookingForm,
                            transactionModel: _cardModel,
                            payload: payload)),
                  );
                },
                enrolOtp: (enrolOtp) {},
                secure3dMpgsRequired:
                    (secure3dRequired) async {
                  var url = secure3dRequired.returnUrl;
                  if (await canLaunch(url)) {
                    await launch(url).then((result){
                      if(result.toString().contains('Success')){
                        _busBookingBloc.dispatch(BookingButtonPressed(
                            widget._bookingForm, secure3dRequired.reference, payload));
                      }
                    });
                  }
                },
                secure3dRequired:
                    (secure3dRequired) async {
                  var url = secure3dRequired.returnUrl;
                  if (await canLaunch(url)) {
                    await launch(url).then((result){
                      if(result.toString().contains('Success')){
                        _busBookingBloc.dispatch(BookingButtonPressed(
                            widget._bookingForm, secure3dRequired.reference, payload));
                      }
                    });
                  }
                },
                error: (error) {
                  FlushbarHelper.createError(
                      message: "$error - An Error Occured")
                    ..show(context);

                  throw Exception(error);
                });
//            TransactionRepository.getInstance(CyberPayApi())
//                .chargeCardApi(cardModelToJson(_cardModel))
//                .then((cardResult) async {
//              var loadingBar = FlushbarHelper.createLoading(
//                  message: cardResult.data.message,
//                  linearProgressIndicator: null);
//              loadingBar..show(context);
//
//              if (cardResult.data.status == "Failed") {
//                var loadingBar = FlushbarHelper.createLoading(
//                    message: cardResult.data.message,
//                    linearProgressIndicator: null);
//                loadingBar..show(context);
//                setState(() {
//                  isSubmitLoading = false;
//                });
//              }
//              if (cardResult.data.status == "Otp") {
//                setState(() {
//                  isSubmitLoading = false;
//                });
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => new HomeScreen(
//                          busSchedule: widget._busSchedule,
//                          bookingForm: widget._bookingForm,
//                          transactionModel: _cardModel,
//                          payload: payload)),
//                );
//              } else if (cardResult.data.status == "Success") {
//                var loadingBar = FlushbarHelper.createLoading(
//                    message:
//                    "Transaction successful: Transaction Ref: ${widget.transactionModel.reference}",
//                    linearProgressIndicator: null);
//                loadingBar..show(context);
//
//                _busBookingBloc.dispatch(BookingButtonPressed(
//                    widget._bookingForm, widget.transactionModel.reference, payload));
//              } else if (cardResult.data.status == "ProvidePin") {
//                var loadingBar = FlushbarHelper.createLoading(
//                    message:
//                    "Transaction successful: Transaction Ref: {${widget.transactionModel.reference}",
//                    linearProgressIndicator: null);
//                loadingBar..show(context);
//
//                setState(() {
//                  isSubmitLoading = false;
//                });
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => new ProvidePinScreen(
//                          busSchedule: widget._busSchedule,
//                          bookingForm: widget._bookingForm,
//                          transactionModel: _cardModel,
//                          payload: payload)),
//                );
//
//              } else if (cardResult.data.status == "Successful") {
//                var loadingBar = FlushbarHelper.createLoading(
//                    message:
//                    "Transaction successful: with Transaction Ref: {${widget.transactionModel.reference}",
//                    linearProgressIndicator: null);
//                loadingBar..show(context);
//
//                _busBookingBloc.dispatch(BookingButtonPressed(
//                    widget._bookingForm, widget.transactionModel.reference, payload));
//              } else if (cardResult.data.status == "EnrollOtp") {
//              } else if (cardResult.data.status == "Secure3D") {
//                var url = cardResult.data.redirectUrl;
//                if (await canLaunch(url)) {
//                  await launch(url).then((result){
//                    _busBookingBloc.dispatch(BookingButtonPressed(
//                        widget._bookingForm, widget.transactionModel.reference, payload));
//                  });
//                }
//              } else if (cardResult.data.status == "Secure3DMpgs") {
//                var url = cardResult.data.redirectUrl;
//                if (await canLaunch(url)) {
//                  await launch(url).then((result){
//                    _busBookingBloc.dispatch(BookingButtonPressed(
//                        widget._bookingForm, widget.transactionModel.reference, payload));
//                  });
//                }
//              }
//
//              loadingBar.dismiss(context);
//            });
          });
    }
  }

  void onOtpModelChange(OtpModel otpModel) {
    setState(() {
      cardPinNumber = otpModel.otpNumber.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    });
  }

  @override
  void initState() {
    super.initState();
    _busBookingBloc = BookingformBloc(schedule: widget._busSchedule, bookingForm: widget._bookingForm);
    _busBookingBloc.dispatch(BookingFormStarted());
  }

  @override
  void dispose() {
    super.dispose();
    _busBookingBloc.dispose();
  }


}

class CardPinForm extends StatefulWidget {
  const CardPinForm({
    Key key,
    this.cardPinNumber,
    @required this.cardPinModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String cardPinNumber;

  final void Function(CardPinModel) cardPinModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;

  @override
  _CardPinFormState createState() => _CardPinFormState();
}

class _CardPinFormState extends State<CardPinForm> {
  String cardPinNumber;

  Color themeColor;

  void Function(CardPinModel) cardPinModelChange;
  CardPinModel cardPinModel;

  final MaskedTextController _otpController =
  MaskedTextController(mask: '0 0 0 0');

  FocusNode cvvFocusNode = FocusNode();

  void createOtpModel() {
    cardPinNumber = widget.cardPinNumber ?? '';

    cardPinModel = CardPinModel(
      cardPinNumber,
    );
  }

  @override
  void initState() {
    super.initState();

    createOtpModel();

    cardPinModelChange = widget.cardPinModelChange;

    _otpController.addListener(() {
      setState(() {
        cardPinNumber = _otpController.text;
        cardPinModel.cardPinNumber = cardPinNumber;
        cardPinModelChange(cardPinModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: TextFormField(
                controller: _otpController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'OTP CODE',
                  hintText: 'x x x x x x',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardPinModel {
  CardPinModel(this.cardPinNumber);

  String cardPinNumber = '';
}

