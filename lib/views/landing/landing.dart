import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/utils/local.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/views/landing/landing_controller.dart';

class Landing extends StatelessWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LandingController());
    return Scaffold(
        backgroundColor: AppColors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  getImage('back.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ));
  }
}
