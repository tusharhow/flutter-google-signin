import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_signin/views/auth/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/homepage.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          if (userCredential.user != null) {
            if (userCredential.user!.uid != null) {
              prefs.setString('userToken', userCredential.user!.uid);
              print(userCredential.user!.uid);
              print(userCredential.user!.displayName);
              Get.offAll(const MyHomePage());
            } else {
              Get.snackbar(
                'Error',
                'User not signed in',
              );
            }
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
    }
  } // logout

  Future<void> logoutUser() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userToken');
    Get.offAll(const GoogleSignInScreen());
    Get.snackbar(
      'Ooops',
      'You have been logged out',
    );
  }
}
