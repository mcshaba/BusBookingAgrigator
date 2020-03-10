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

class HomeScreen extends StatefulWidget {
  final CardModel transactionModel;

  final BusSchedule _busSchedule;
  final BookingForm _bookingForm;
    final String _payload;

  const HomeScreen(
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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BookingformBloc _busBookingBloc;
  bool isSubmitLoading = false;

  String otpNumber = '';

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
                          Navigator.pushReplacementNamed(context, HomeViewRoute);
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
                  otpNumber: otpNumber.trim(),
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
            "Verify OTP",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            setState(() {
              isSubmitLoading = true;
            });

            OtpRequestModel _otpModel = OtpRequestModel(
                otp: otpNumber,
                reference: widget.transactionModel.reference);
            widget.transactionModel.otp = otpNumber;

            TransactionRepository.getInstance(CyberPayApi())
                .verifyOtpApi(encodedBody: otpRequestModelToJson(_otpModel),
            success: (result, message){
              var loadingBar = FlushbarHelper.createLoading(
                  message: result,
                  linearProgressIndicator: null);
              loadingBar..show(context);
              setState(() {
                isSubmitLoading = false;
              });
              _busBookingBloc.dispatch(BookingButtonPressed(widget._bookingForm, widget.transactionModel.reference, widget._payload));

              loadingBar..dismiss(context);
            }, error: (error){
                  var loadingBar = FlushbarHelper.createLoading(
                      message: error,
                      linearProgressIndicator: null);
                  loadingBar..show(context);
                  setState(() {
                    isSubmitLoading = false;
                  });
                  loadingBar.dismiss(context);
                });
//                .then((result) {
//              var loadingBar = FlushbarHelper.createLoading(
//                  message: result.data.status,
//                  linearProgressIndicator: null);
//              loadingBar..show(context);
//              setState(() {
//                isSubmitLoading = false;
//              });
//              if (result.data.status == "Successful") {
//
//                _busBookingBloc.dispatch(BookingButtonPressed(widget._bookingForm, widget.transactionModel.reference, widget._payload));
//
//                loadingBar..dismiss(context);
//              } else {
//                setState(() {
//                  isSubmitLoading = false;
//                });
//                loadingBar.dismiss(context);
//              }
//            });
          });
    }
  }

  void onOtpModelChange(OtpModel otpModel) {
    setState(() {
      otpNumber = otpModel.otpNumber.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
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
