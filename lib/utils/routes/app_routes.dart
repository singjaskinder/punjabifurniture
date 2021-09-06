import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/views/auth/forgot_password/forgot_password.dart';
import 'package:punjabifurniture/views/auth/login/login.dart';
import 'package:punjabifurniture/views/landing/landing.dart';
import 'package:punjabifurniture/views/navigator/buildnavigator.dart';

class Routes {
  static const String landing = '/landing';
  static const String login = '/login';
  static const String forgotPassword = '/forgotPassword';
  static const String home = '/home';

  static void back() => Get.back();

  static final List<GetPage> pages = [
    GetPage(name: landing, page: () => Landing()),
    GetPage(name: login, page: () => Login()),
    GetPage(name: forgotPassword, page: () => Forgotpassword()),
    GetPage(
      name: home,
      page: () => BuildNavigator(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  final firebaseAuth = FirebaseAuth.instance;
  RouteSettings? redirect(String? route) {
    return firebaseAuth.currentUser == null
        ? RouteSettings(name: '/login')
        : null;
  }
}
