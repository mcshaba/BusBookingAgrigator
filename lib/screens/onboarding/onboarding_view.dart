import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safejourney/bloc/authentication_event.dart';
import 'package:safejourney/bloc/bloc.dart';
import 'package:safejourney/bloc/login/bloc/bloc.dart';
import 'package:safejourney/bloc/login/bloc/login_bloc.dart';
import 'package:safejourney/bloc/login/bloc/login_event.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/repository/user_repository.dart';
import 'package:safejourney/screens/onboarding/data/onboarding_page_data.dart';
import 'package:safejourney/themes/styles.dart';
import 'package:safejourney/utilities/flushbar_helper.dart';

import 'widgets/onboarding_widget.dart';
// import 'widgets/page_view_indicator.dart';

class OnboardingViewScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const OnboardingViewScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        builder: (context) => LoginBloc(
            userRepository: _userRepository,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        child: OnboardingView(userRepository: _userRepository),
      ),
    );
  }
}

class OnboardingView extends StatelessWidget {
  final UserRepository _userRepository;

  OnboardingView({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocListener<LoginBloc, LoginState>(
        // bloc: BlocProvider.of<LoginBloc>(context),
        // Listener is the place for logging, showing Snackbars, navigating, etc.
        // It is guaranteed to run only once per state change.
        listener: (context, state) {
          if (state.isFailure) {
              FlushbarHelper.createError(
                            message: "${state.error}")
                        .show(context);
          }
          if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          return Stack(
            children: <Widget>[
              PageView.builder(
                controller: pageController,
                itemCount: onboardData.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return OnboardWidget(
                    pageController: pageController,
                    pageModel: onboardData[index],
                  );
                },
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 160.0, left: 0),
              //     child: PageViewIndicator(
              //       controller: pageController,
              //       itemCount: onboardData.length,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 80.0, left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildSkipButton(context, state),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Container(
                          height: 44,
                          child: RaisedButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pushNamed(LoginViewRoute,
                                  arguments: _userRepository);
                            },
                            child: Text(
                              'Get Started',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Expanded buildSkipButton(BuildContext context, LoginState state) {
    if (state.isSubmitting) {
      return Expanded(
        child: Container(
          height: 44,
          child: OutlineButton(
            borderSide: BorderSide(color: Colors.white),
            onPressed: () {},
            child: SpinKitThreeBounce(
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: Container(
          height: 44,
          child: OutlineButton(
            borderSide: BorderSide(color: Colors.white),
            onPressed: () {
              BlocProvider.of<LoginBloc>(context).dispatch(
                LoginAsGuestPressed(),
              );
              // Navigator.of(context).pushNamed(HomeViewRoute);

              // Navigator.of(context).pushReplacementNamed(HomeViewRoute,
              //     arguments: widget._userRepository);
            },
            child: Text(
              'Skip',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
  }
}
