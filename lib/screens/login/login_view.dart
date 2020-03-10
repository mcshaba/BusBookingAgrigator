import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safejourney/bloc/bloc.dart';
import 'package:safejourney/bloc/login/bloc/bloc.dart';
import 'package:safejourney/bloc/phoneverification/bloc/bloc.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/navigation/router_arguments.dart';
import 'package:safejourney/repository/user_repository.dart';
import 'package:safejourney/themes/styles.dart';
import 'package:safejourney/utilities/flushbar_helper.dart';
import 'package:safejourney/utilities/validators.dart';

class LoginView extends StatelessWidget {
  final UserRepository _userRepository;
  const LoginView({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        title: Text(''),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider<PhoneverificationBloc>(
        builder: (context) => PhoneverificationBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        child: LoginForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  String verificationId;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
    _smsCodeController.dispose();
  }

  Widget buildNumberLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'What\'s your number?',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.blueGrey[800],
            fontSize: 28.0,
            fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget buildLoginView(PhoneverificationState state) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildNumberLabel(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'We\'ll text a code to verify your phone number. We need this number only to login & we will ensure your details are private.',
                      textAlign: TextAlign.start,
                      style: mediumTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      obscureText: false,
                      autovalidate: true,
                      validator: (value) {
                        if (Validators.isValidPhone(value)) {
                          return null;
                        } else {
                          return 'Provide an actual phone number';
                        }
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: const Color(0xFFE0E0E0), width: 0.1)),
                        hintText: '',
                        labelText: 'Phone',
                        prefixText: '+234',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                          height: 44,
                          child: _buildNextButton(context, state)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNextButton(BuildContext context, PhoneverificationState state) {
    if (state is PhoneVerificationLoading) {
      return FlatButton(
        color: Colors.blueGrey[700],
        onPressed: () {
          _sendCodeToPhoneNumber();
        },
        child: SpinKitThreeBounce(
          color: Colors.white,
          size: 20,
        ),
      );
    } else {
      return FlatButton(
        color: Colors.blueGrey[700],
        onPressed: () {

          if (_phoneNumberController.text.isNotEmpty && Validators.isValidPhone(_phoneNumberController.text)) {
            BlocProvider.of<PhoneverificationBloc>(context)
                .dispatch(PhoneNextButtonPressedEvent());
            _sendCodeToPhoneNumber();
            return null;
          } else {
            return 'Provide an correct phone number';
          }
        },
        child: Text(
          'Next',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      );
    }
  }

  Widget _codeVerifyView(BuildContext context, PhoneverificationState state) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildCodeLabel(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'We just sent a code to +234${_phoneNumberController.text}. Enter the code in that message',
                        textAlign: TextAlign.start,
                        style: smallTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _smsCodeController,
                        obscureText: false,
                        validator: (value) {
                          if (Validators.isPhoneCodeValid(value)) {
                            return null;
                          } else {
                            return 'Ensure your code is 6 digit';
                          }
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: const Color(0xFFE0E0E0), width: 0.1)),
                          hintText: '',
                          labelText: '6 Digit Code',
                        ),
                      ),
                    ),
                    MaterialButton(
                        child: Text(
                          'Send the code again',
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          BlocProvider.of<PhoneverificationBloc>(context)
                              .dispatch(PhoneNextButtonPressedEvent());
                          _sendCodeToPhoneNumber();
                        }),
                    MaterialButton(
                        child: Text(
                          'Change my number',
                          style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          BlocProvider.of<PhoneverificationBloc>(context)
                              .dispatch(ChangeNumberEvent());
                        }),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                          height: 44,
                          child: _buildVerifyButton(context, state),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVerifyButton(
      BuildContext context, PhoneverificationState state) {
    if (state is CodeVerificationLoading) {
      return FlatButton(
        color: Colors.blueGrey[700],
        onPressed: () {
          _signInWithPhoneNumber(_smsCodeController.text);
        },
        child: SpinKitThreeBounce(
          color: Colors.white,
          size: 20,
        ),
      );
    } else {
      return FlatButton(
        color: Colors.blueGrey[700],
        onPressed: () {
          if(_smsCodeController.text.isNotEmpty && _smsCodeController.text.length > 3){
            BlocProvider.of<PhoneverificationBloc>(context)
                .dispatch(CodeVerifyButtonPressedEvent());
            _signInWithPhoneNumber(_smsCodeController.text);
          }
        },
        child: Text(
          'Verify',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PhoneverificationBloc, PhoneverificationState>(
          listener: (context, state) {
        if (state is PhoneVerificationLoading) {
          FlushbarHelper.createLoading(
                  message: "Trying to auto retrieve code sent")
              .show(context);
        }
        if (state is PhoneVerificationFailure) {
          FlushbarHelper.createError(message: "${state.error}").show(context);
        }
        if (state is CodeVerificationFailure) {
          FlushbarHelper.createError(message: "${state.error}").show(context);
        }
        //  if (state is CodeVerificationLoading) {
        //   FlushbarHelper.createLoading(message: "Loading your").show(context);
        // }
        if (state is CodeVerificationSuccess) {
          Navigator.of(context).pushReplacementNamed(HomeViewRoute);
        }
      }, child: BlocBuilder<PhoneverificationBloc, PhoneverificationState>(
        builder: (context, state) {
          if (state is InitialPhoneverificationState) {
            return buildLoginView(state);
          }
          return _codeVerifyView(context, state);
          // if (state is InitialCodeverificationState || state is CodeVerificationFailure || state is CodeVerificationLoading) {
          //   return _codeVerifyView(context);
          // } else {
          //   return buildLoginView(state);
          // }
        },
      )),
    );
  }

  Widget buildCodeLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'Enter 6 - digit code',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.blueGrey[800],
            fontSize: 28.0,
            fontWeight: FontWeight.w800),
      ),
    );
  }

  /// Sign in using an sms code as input.
  void _signInWithPhoneNumber(String smsCode) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    var authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      await FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .then((FirebaseUser user) async {
        final FirebaseUser currentUser =
            await FirebaseAuth.instance.currentUser();
        assert(user.uid == currentUser.uid);
        print('signed in with phone number successful: user -> $user');
        BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        // Navigator.of(context).pushReplacementNamed(HomeViewRoute);
      });
    } catch (error) {
      BlocProvider.of<PhoneverificationBloc>(context)
          .dispatch(CodeVerificationFailureEvent(error: error.message));
    }
  }

  //* Sends the code to the specified phone number.
  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (credential) async {
      //*This callback will be invoked in two situations:
      //* 1 - Instant verification. In some cases the phone number can be instantly
      //* verified without needing to send or enter a verification code.
      //*
      //* 2 - Auto-retrieval. On some devices Google Play services can automatically
      //** detect the incoming verification SMS and perform verification without  user action.

      try {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((FirebaseUser user) async {
          final FirebaseUser currentUser =
              await FirebaseAuth.instance.currentUser();
          assert(user.uid == currentUser.uid);

          BlocProvider.of<PhoneverificationBloc>(context)
              .dispatch(CodeVerifySuccessEvent());
          // BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          // Navigator.of(context).pushReplacementNamed(HomeViewRoute);

          print('signed in with phone number successful: user -> $user');
        });
      } catch (PlatformException, e) {
        print('${e.toString()}');
      }
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      //* This callback is invoked in an invalid request for verification is made,
      // *for instance if the the phone number format is not valid.
      BlocProvider.of<PhoneverificationBloc>(context)
          .dispatch(PhoneSentFailureEvent(error: authException.message));
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+234${_phoneNumberController.text}',
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
