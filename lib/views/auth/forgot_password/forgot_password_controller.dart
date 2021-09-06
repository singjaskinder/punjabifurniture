import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/apis/auth.dart';
import 'package:punjabifurniture/utils/overlays/dialog.dart';
import 'package:punjabifurniture/utils/overlays/progress_dialog.dart';
import 'package:punjabifurniture/utils/routes/app_routes.dart';

class ForgotpasswordController extends GetxController {
  final authApis = AuthRepo();

  final emailCtrl = TextEditingController();

  void sendLink() async {
    if (emailCtrl.text.isEmpty) {
      BuildDialog(description: 'Email cannot be empty');
      return;
    } else if (emailCtrl.text.isEmail) {
      try {
        isLoading(true);
        await authApis.sendPasswordLink(emailCtrl.text.trim());
        isLoading(false);
        BuildDialog(
          title: 'Confirmation',
          description: 'Password reset link sent, Please check your mail.',
        );
        emailCtrl.clear();
      } on FirebaseAuthException catch (e) {
        print(e);
        isLoading(false);
        if (e.code.toString().contains('user-not-found')) {
          BuildDialog(description: 'Entered email not found...');
        } else {
          BuildDialog();
        }
      }
    } else {
      BuildDialog(description: 'Enter valid email');
    }
    // jethro0056@gmail.com
  }

  void toBuildNavigation() {
    // Get.toNamed();
  }

  void toLogin() {
    Get.offNamed(Routes.login);
  }
}
