import 'dart:math';
import 'package:cyberpaysdkflutter/src/models/OtpRequestModel.dart';

import 'package:cyberpaysdkflutter/ui/credit_card_model.dart';
import 'package:flutter/material.dart';
import 'package:cyberpaysdkflutter/ui/flutter_credit_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safejourney/bloc/booking/bloc/bloc.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_bloc.dart';
import 'package:safejourney/bloc/booking/bloc/bookingform_event.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/model/booking_form.dart';
import 'package:safejourney/model/search_bus_model.dart';
import 'package:safejourney/screens/otp_screen.dart';
import 'package:safejourney/screens/provide_pin_view.dart';
import 'package:safejourney/utilities/flushbar_helper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CyberPayView extends StatefulWidget {
  final BusSchedule _busSchedule;
  final BookingForm _bookingForm;

  const CyberPayView(
      {Key key,
      @required BusSchedule busSchedule,
      @required BookingForm bookingForm})
      : assert(busSchedule != null),
        _bookingForm = bookingForm,
        _busSchedule = busSchedule,
        super(key: key);

  @override
  _CyberPayViewState createState() => _CyberPayViewState();
}

class _CyberPayViewState extends State<CyberPayView> {
  BookingformBloc _busBookingBloc;

  final CardModel _model = CardModel();
  TextEditingController _amountController;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CardModel>(
      model: _model,
      child: MaterialApp(
        title: 'Cyber Pay Card',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: BlocProvider(
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

//                        {
//                          "Currency":"NGN",
//                          "MerchantRef":"kasds94573p945734p537adsa",
//                          "Amount":2100000,
//                          "Description":"Hello",
//                          "CustomerName":"sample",
//                          "CustomerEmail":"sampl@gmail.com",
//                          "CustomerMobile":"2347039555295",
//                          "IntegrationKey":"d5355204f9cf495f853c8f8d26ada19b",
//                          "ReturnUrl":"https://www.google.com/"
//                        }
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
            child: CardPage(
                busSchedule: widget._busSchedule,
                bookingForm: widget._bookingForm),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _amountController = TextEditingController();

    _busBookingBloc = BookingformBloc(
        schedule: widget._busSchedule, bookingForm: widget._bookingForm);
    _busBookingBloc.dispatch(BookingFormStarted());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _busBookingBloc.dispose();
    super.dispose();
  }

  //_busBookingBloc.dispatch(BookingButtonPressed());

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

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      //cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

class CardPage extends StatefulWidget {
  final BusSchedule _busSchedule;
  final BookingForm _bookingForm;

  const CardPage(
      {Key key,
      @required BusSchedule busSchedule,
      @required BookingForm bookingForm})
      : assert(busSchedule != null),
        _busSchedule = busSchedule,
        _bookingForm = bookingForm,
        super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  TextEditingController _amountController;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String cardPin = '';
  bool isCvvFocused = false;

  double amount;

  bool isSubmitLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    amount = widget._bookingForm.tripAmount;
    cardHolderName = widget._bookingForm.passengerName;
    _amountController.text = amount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CardModel>(
      builder: (BuildContext context, Widget child, CardModel model) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                CreditCardWidget(
                  cardNumber: cardNumber.trim(),
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  cardPin: cardPin,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, top: 8, right: 16, bottom: 8),
                  child: _buildAmountWidget(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: CreditCardForm(
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                  ),
                ),
                _buildSubmitButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmountWidget() {
    return Container(
      child: TextFormField(
        autocorrect: false,
        enabled: false,
        keyboardType: TextInputType.number,
        decoration: defaultTextFieldInputDecoration(label: 'Amount'),
        maxLines: 1,
        controller: _amountController,
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

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      //cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
      cardPin = creditCardModel.cardPin;
    });
  }

  _buildSubmitButton() {
    final BookingformBloc _busBookingBloc =
        BlocProvider.of<BookingformBloc>(context);

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
        child: new Text(
          "Pay Now",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          setState(() {
            isSubmitLoading = true;
          });
          var loadingBar = FlushbarHelper.createLoading(
              message: "Please wait...Transaction processing.",
              linearProgressIndicator: LinearProgressIndicator())
            ..show(context);
          var splitDate = expiryDate.split("/");

          var randomizer = new Random(); // can get a seed as a parameter

          // Integer between 0 and 100 (0 can be 100 not)
          var num = randomizer.nextInt(1097640);
          var numb = randomizer.nextInt(1096640);
          String merch_reference = 'SJ' + num.toString() + numb.toString();
          double cyberAmount = widget._busSchedule.mySplit[0].amount;
          bool cyberdeductFrom = widget._busSchedule.mySplit[0].shouldDeductFrom;
          String cyberWalletCode = widget._busSchedule.mySplit[0].walletCode;

          double busAmount = widget._busSchedule.mySplit[1].amount;
          bool busDeductFrom =  widget._busSchedule.mySplit[1].shouldDeductFrom;
          String busWalletCode = widget._busSchedule.mySplit[1].walletCode;



          Splits _split0 = Splits(amount: cyberAmount, shouldDeductFrom: cyberdeductFrom, walletCode: cyberWalletCode);
          Splits _split1 = Splits(amount: busAmount, shouldDeductFrom: busDeductFrom, walletCode: busWalletCode);

          List<Splits> split = new List();
          split.add(_split0);
          split.add(_split1);

          TransactionModel _transModel = TransactionModel(
            merchantRef: merch_reference,
            amount: int.parse(_amountController.text) * 100,
            customerEmail: widget._bookingForm.passengerEmail,
            integrationKey: widget._busSchedule.integrationKey,//"d5355204f9cf495f853c8f8d26ada19b"
            returnUrl: "https://www.safejourney.ng/",
            customerMobile: widget._bookingForm.passengerPhone,
            customerName: widget._bookingForm.passengerName,
            description: "Transaction from Flutter SDK",
            splits: split,
          );

          TransactionRepository.getInstance(CyberPayApi())
              .beginTransactionApi(encodedBody: transactionModelToJson(_transModel), success: (reference, message){
            loadingBar.dismiss(context);

            if (reference != null) {
              CardModel _charge = CardModel(
                  name: widget._bookingForm.passengerName,
                  cardNumber:
                  cardNumber.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
                  expiryMonth: int.parse(splitDate[0]),
                  expiryYear: int.parse(splitDate[1]),
                  cvv: cvvCode,
                  cardPin: cardPin,
                  reference: reference);

              String payload = '';
              TransactionRepository.getInstance(CyberPayApi())
                  .getEncodedPayload(cardModelToJson(_charge))
                  .then((payloadResult) {
                payload = payloadResult;
              });

              TransactionRepository.getInstance(CyberPayApi())
                  .chargeCardApi(
                  encodedBody: cardModelToJson(_charge),
                  success: (success, message) {
                    var loadingBar =
                    FlushbarHelper.createLoading(
                        message:
                        "Transaction successful: Transaction Ref: {$success}",
                        linearProgressIndicator:
                        null);
                    loadingBar..show(context);

                    _busBookingBloc.dispatch(BookingButtonPressed(
                        widget._bookingForm, reference, payload));
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
                              transactionModel: _charge,
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
                              transactionModel: _charge,
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
                                  widget._bookingForm, reference, payload));
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
                                  widget._bookingForm, reference, payload));
                            }
                          });
                        }
                  },
                  error: (error) {
                    FlushbarHelper.createError(
                        message: "$error - An Error Occured")
                      ..show(context);
                    setState(() {
                      isSubmitLoading = false;
                    });

                    throw Exception(error);
                  });
            } else {
              loadingBar = FlushbarHelper.createError(
                  message: "An Error Occured")
                ..show(context);
              setState(() {
                isSubmitLoading = false;
              });
            }
          }, error: (error){
            FlushbarHelper.createError(
                message: "$error - An Error Occured")
              ..show(context);
            setState(() {
              isSubmitLoading = false;
            });
            throw Exception(error);
          });
//              .beginTransactionApi(transactionModelToJson(_transModel))
//              .then((result) {
//            loadingBar.dismiss(context);
//
//            var reference = result.data.transactionReference;
//
//            CardModel _charge = CardModel(
//                name: widget._bookingForm.passengerName,
//                cardNumber:
//                    cardNumber.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
//                expiryMonth: int.parse(splitDate[0]),
//                expiryYear: int.parse(splitDate[1]),
//                cvv: cvvCode,
//                cardPin: cardPin,
//                reference: reference);
//
//            String payload = '';
//            TransactionRepository.getInstance(CyberPayApi())
//                .getEncodedPayload(cardModelToJson(_charge))
//                .then((payloadResult) {
//              payload = payloadResult;
//            });
//
//            TransactionRepository.getInstance(CyberPayApi())
//                .chargeCardApi(cardModelToJson(_charge))
//                .then((cardResult) async {
//              var loadingBar = FlushbarHelper.createLoading(
//                  message: cardResult.data.message,
//                  linearProgressIndicator: null);
//              loadingBar..show(context);
//
//              if (cardResult.data.status == "Failed") {
//                var loadingBar = FlushbarHelper.createLoading(
//                    message: cardResult.data.message != null ? cardResult.data.message : cardResult.message,
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
//                          transactionModel: _charge,
//                          payload: payload)),
//                );
//              } else if (cardResult.data.status == "Success") {
//                var loadingBar = FlushbarHelper.createLoading(
//                    message:
//                        "Transaction successful: Transaction Ref: {$reference}",
//                    linearProgressIndicator: null);
//                loadingBar..show(context);
//
//                _busBookingBloc.dispatch(BookingButtonPressed(
//                    widget._bookingForm, reference, payload));
//              } else if (cardResult.data.status == "ProvidePin") {
//                var loadingBar = FlushbarHelper.createLoading(
//                    message:
//                        "Transaction successful: Transaction Ref: {$reference}",
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
//                          transactionModel: _charge,
//                          payload: payload)),
//                );
//
//
//
//              } else if (cardResult.data.status == "Successful") {
//                var loadingBar = FlushbarHelper.createLoading(
//                    message:
//                        "Transaction successful: with Transaction Ref: {$reference}",
//                    linearProgressIndicator: null);
//                loadingBar..show(context);
//
//                _busBookingBloc.dispatch(BookingButtonPressed(
//                    widget._bookingForm, reference, payload));
//              } else if (cardResult.data.status == "EnrollOtp") {
//              } else if (cardResult.data.status == "Secure3D") {
//                var url = cardResult.data.redirectUrl;
//                if (await canLaunch(url)) {
//                  await launch(url).then((result){
//                    if(result.toString().contains('Success')){
//                      _busBookingBloc.dispatch(BookingButtonPressed(
//                          widget._bookingForm, reference, payload));
//                    }
//                  });
//                }
//              } else if (cardResult.data.status == "Secure3DMpgs") {
//                var url = cardResult.data.redirectUrl;
//                if (await canLaunch(url)) {
//                  await launch(url).then((result){
//                    if(result.toString().contains('Success')){
//                      _busBookingBloc.dispatch(BookingButtonPressed(
//                          widget._bookingForm, reference, payload));
//                    }
//                  });
//                }
//              }
//
//              loadingBar.dismiss(context);
//            });
//          });
        },
      );
    }
  }
}
