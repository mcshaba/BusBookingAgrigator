import 'dart:core' as prefix0;
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:safejourney/utilities/exceptions.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<FirebaseUser> _signInWithPhoneNumber(
      String smsCode, String verificationId) async {
    final AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);

    _firebaseAuth.signInWithCredential(authCredential);

    return _firebaseAuth.currentUser();
  }

  //* Make sure to pass in a phone number with country code prefixed with plus sign ('+').

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try{
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: (user) {
          print("User: $user");
        },
        verificationFailed: (AuthException authException) {
          print("exception: $authException");
        },
        codeSent: (String verifId, [int forceSent]) {
          print("verificannId: $verifId");
          return verifId;
        },
        codeAutoRetrievalTimeout: (String timeOut) {
          print("Time out: " + timeOut);
        });
    }
    catch (exception){
        rethrow;
    }

  }

  Future<void> signInAsGuest() async {
    return Future.wait(
        [_firebaseAuth.signInAnonymously(), _firebaseAuth.currentUser()]);
  }

  // await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: _phoneNumberController.text,
  //       timeout: const Duration(seconds: 5),
  //       verificationCompleted: verificationCompleted,
  //       verificationFailed: verificationFailed,
  //       codeSent: codeSent,
  //       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  // }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }
}
