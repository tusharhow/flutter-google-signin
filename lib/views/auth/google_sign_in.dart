import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class GoogleSignInScreen extends StatelessWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'User is not logged in yet',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Sign in with Google'),
              onPressed: () {
                controller.signInWithGoogle(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
