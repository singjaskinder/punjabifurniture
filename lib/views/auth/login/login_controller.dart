import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/apis/auth.dart';
import 'package:punjabifurniture/models/user_m.dart';
import 'package:punjabifurniture/utils/functions/preferences.dart';
import 'package:punjabifurniture/utils/overlays/dialog.dart';
import 'package:punjabifurniture/utils/overlays/progress_dialog.dart';
import 'package:punjabifurniture/utils/routes/app_routes.dart';

class LoginController extends GetxController {
  final authApis = AuthRepo();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void login() async {
    emailCtrl.text = 'viper@gmail.com';
    passwordCtrl.text = '1234567890';
    // emailCtrl.text = 'admin@email.com';
    // passwordCtrl.text = 'qwertyuiop';
    if (emailCtrl.text.isEmpty) {
      BuildDialog(description: 'Email cannot be empty');
      return;
    }
    if (passwordCtrl.text.isEmpty) {
      BuildDialog(description: 'Password cannot be empty');
      return;
    }
    if (passwordCtrl.text.length <= 6) {
      BuildDialog(description: 'Password should contain minimum 6 characters');
      return;
    }
    if (emailCtrl.text.isEmail) {
      try {
        isLoading(true);
        final user =
            UserM(id: passwordCtrl.text.trim(), email: emailCtrl.text.trim());
        await authApis.login(user);
        final userM = await authApis.getDetails(user);
        Preferences.saveUserDetails(userM);
        isLoading(false);
        toBuildNavigation();
      } on FirebaseAuthException catch (e) {
        print(e);
        isLoading(false);
        if (e.code.toLowerCase() == 'wrong-password') {
          BuildDialog(description: 'Entered password is incorrect');
        } else if (e.code.toLowerCase() == 'user-not-found') {
          BuildDialog(description: 'User not found with given details');
        } else if (e.code.toLowerCase() ==
            'firebase_auth/email-already-in-use') {
          BuildDialog(
              description:
                  'The email address is already in use by another user');
        } else {
          BuildDialog();
        }
      }
    } else {
      BuildDialog(description: 'Enter valid email');
    }
  }

  void toBuildNavigation() {
    Get.offNamed(Routes.home, arguments: 'qwiodjwoiq');
  }

  void toForgotPassword() {
    Get.offNamed(Routes.forgotPassword);
  }
}
