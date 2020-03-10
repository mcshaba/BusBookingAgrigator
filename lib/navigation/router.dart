import 'package:flutter/material.dart';
import 'package:safejourney/constants/routing_constants.dart';
import 'package:safejourney/screens/book_status_resut.dart';
import 'package:safejourney/screens/booking_screen.dart';
import 'package:safejourney/screens/booking_status_view.dart';
import 'package:safejourney/screens/cyberpay_view.dart';
import 'package:safejourney/screens/home_view.dart';
import 'package:safejourney/screens/login/login_view.dart';
import 'package:safejourney/screens/onboarding/onboarding_view.dart';
import 'package:safejourney/screens/splash_screen_view.dart';
import 'package:safejourney/screens/state_search_view.dart';
import 'package:safejourney/screens/trip_result_view.dart';
import 'package:safejourney/screens/undefined_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnboardingScreenRoute:
      var arguments = settings.arguments;
      return MaterialPageRoute(
          builder: (context) =>
              OnboardingViewScreen(userRepository: arguments));
      break;
    case SplashScreenRoute:
      return MaterialPageRoute(builder: (context) => SplashScreenView());
      break;
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => HomeView());
      break;
    case TripResultScreenRoute:
      var arguments = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => TripResultScreen(
                tripArguments: arguments,
              ));
      break;
    case BookingStatusResult:
      var arguments = settings.arguments;
      return MaterialPageRoute(builder: (context) => BookingStatusResultView(bookingReference: arguments));
    case BookingScreenRoute:
          var arguments = settings.arguments;
      return MaterialPageRoute(builder: (context) => BookingScreen(busSchedule: arguments,));
      break;
    case CyberPay:
      var arguments = settings.arguments;
      return MaterialPageRoute(builder: (context) => CyberPayView(busSchedule: arguments,));
      break;
    case BookingStatus:
      return MaterialPageRoute(builder: (context) => BookingStatusView());
    case LoginViewRoute:
      var arguments = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => LoginView(userRepository: arguments));
      break;
    case StateSearchRoute:
      return MaterialPageRoute(builder: (context) => StateSearchView());
      break;
    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedView(
                name: settings.name,
              ));
  }
}
