import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_sigin/screens/login.dart';
import 'package:getx_sigin/screens/signup.dart';
import 'package:getx_sigin/screens/welcome.dart';

class AuthContoller extends GetxController {
// AuthController.instance

  static AuthContoller instance = Get.find();

// includes emails, password, name....
  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);

// Our user will be notified
    _user.bindStream(auth.userChanges());

    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print("Login page");
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() => WelcomeScreen(email: user.email!));
    }
  }

  void register(String email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Get.snackbar(
        "About User",
        "User message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account creation failed",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar(
        "About Login",
        "Login message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Login failed",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void logOut() async {
    await auth.signOut();
  }
}
