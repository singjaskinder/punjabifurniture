import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {
  static final robotoM = 'RobotoM';

  static final robotoB = 'RobotoB';

  static final darkGradient = LinearGradient(
    colors: [
      AppColors.brown,
      AppColors.darkBrown,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.2, 1.0],
  );

  static final lightGradient = LinearGradient(
    colors: [
      AppColors.brown,
      AppColors.white,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.2, 1.0],
  );

  static final violetSplash = AppColors.brown.withOpacity(0.5);
  static final whiteSplash = AppColors.white.withOpacity(0.5);

  static final primaryTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );

  static final primaryTextFieldDecor = InputDecoration(
    errorStyle: TextStyle(fontSize: 0.1, color: AppColors.darkRed),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.white, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.white, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.white, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3), width: 1),
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red, width: 1.5),
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    isDense: true,
  );

  static final textFieldShadow = BoxShadow(
      color: AppColors.black.withOpacity(0.1),
      spreadRadius: 1,
      blurRadius: 2,
      offset: Offset(-1, 1));

  static final buttonShadow = BoxShadow(
      color: AppColors.black.withOpacity(0.3),
      spreadRadius: 1,
      blurRadius: 10,
      offset: Offset(0, 2));

  static final tileShadow = BoxShadow(
      color: AppColors.black.withOpacity(0.15),
      spreadRadius: 0.5,
      blurRadius: 4,
      offset: Offset(0, 0));

  static final tileShadowDark = BoxShadow(
      color: AppColors.black.withOpacity(0.3),
      spreadRadius: 0.5,
      blurRadius: 4,
      offset: Offset(0, 0));
}
