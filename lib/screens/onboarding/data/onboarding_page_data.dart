import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:safejourney/screens/onboarding/models/onboarding_page_model.dart';

List<OnboardPageModel> onboardData = [
  OnboardPageModel(
    primaryColor: Colors.white,
    accentColor: Color(0X0a2463),
    pageNumber: 0,
    caption: 'Plan Your Trips Easily',
    description:
        'Find trips anywhere within Nigeria, easily get bus stations closest to you',
    imagePath: 'images/screen1.png',
  ),
  OnboardPageModel(
    primaryColor: Colors.white,
      accentColor: Color(0X0a2463),
      pageNumber: 1,
      caption: 'All trips history in one place',
      description: 'Easily find your reservations from previous trips',
      imagePath: 'images/screen2.png'),
  OnboardPageModel(
    primaryColor: Colors.white,
      accentColor: Color(0X0a2463),
      pageNumber: 2,
      caption: 'Get amazing trip deals',
      description:
          'Be the first to get notifications on trip deals, get discounts from your favorite travel agencies and many more.',
          imagePath: 'images/screen3.png'),
];
