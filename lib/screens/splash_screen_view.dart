import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safejourney/constants/routing_constants.dart';

class SplashScreenView extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Welcome to safejourney.ng'),
      ),
      // body: Center(
      //   child: Image.asset('assets/splash.png'),
      // ),
    );
  }
}
