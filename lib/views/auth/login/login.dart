import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:punjabifurniture/common/buttons.dart';
import 'package:punjabifurniture/common/sized_box.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/utils/local.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/res/app_styles.dart';
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'login_controller.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => LoginMobile(),
      desktop: (BuildContext context) => LoginDesktop(),
    );
  }
}

class LoginDesktop extends StatelessWidget {
  const LoginDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find();
    return Scaffold(
        backgroundColor: AppColors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  getImage('back.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                width: SizeConfig.widthMultiplier * 45,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: BuildText(
                        'Punjabi Furniture',
                        size: 3,
                        fontFamily: GoogleFonts.bebasNeue().fontFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                        color: AppColors.darkerBrown,
                      ),
                    ),
                    BuildSizedBox(),
                    TextField(
                      controller: controller.emailCtrl,
                      style: AppStyles.primaryTextStyle.copyWith(fontSize: 18),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: AppColors.brown.withOpacity(0.1),
                      ),
                    ),
                    BuildSizedBox(),
                    TextField(
                      controller: controller.passwordCtrl,
                      obscureText: true,
                      style: AppStyles.primaryTextStyle.copyWith(fontSize: 18),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: AppColors.brown.withOpacity(0.1),
                      ),
                    ),
                    BuildSecondaryButton(
                      onTap: () => controller.toForgotPassword(),
                      label: 'Forgot Password?',
                      fontColor: AppColors.grey,
                      fontSize: 1,
                    ),
                    BuildSizedBox(
                      height: 3,
                    ),
                    BuildPrimaryButton(
                      onTap: () => controller.login(),
                      label: 'Login',
                      fontSize: 1.8,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class LoginMobile extends StatelessWidget {
  const LoginMobile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find();
    return Scaffold(
        backgroundColor: AppColors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  getImage('back.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: BuildText(
                        'Punjabi Furniture',
                        size: 6,
                        fontFamily: GoogleFonts.bebasNeue().fontFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                        color: AppColors.darkerBrown,
                      ),
                    ),
                    BuildSizedBox(),
                    TextField(
                      controller: controller.emailCtrl,
                      style: AppStyles.primaryTextStyle.copyWith(fontSize: 15),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: AppColors.brown.withOpacity(0.1),
                          isDense: true),
                    ),
                    BuildSizedBox(),
                    TextField(
                      controller: controller.passwordCtrl,
                      obscureText: true,
                      style: AppStyles.primaryTextStyle.copyWith(fontSize: 15),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: AppColors.brown.withOpacity(0.1),
                          isDense: true),
                    ),
                    BuildSecondaryButton(
                      onTap: () => controller.toForgotPassword(),
                      label: 'Forgot Password?',
                      fontColor: AppColors.grey,
                    ),
                    BuildSizedBox(
                      height: 3,
                    ),
                    BuildPrimaryButton(
                      onTap: () => controller.login(),
                      label: 'Login',
                      fontSize: 2.8,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
