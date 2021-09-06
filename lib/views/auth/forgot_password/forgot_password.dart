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
import 'forgot_password_controller.dart';

class Forgotpassword extends StatelessWidget {
  const Forgotpassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotpasswordController());
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => ForgotpasswordMobile(),
      desktop: (BuildContext context) => ForgotpasswordDesktop(),
    );
  }
}

class ForgotpasswordDesktop extends StatelessWidget {
  const ForgotpasswordDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ForgotpasswordController controller = Get.find();
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
                    BuildText(
                      'Forgot Password?',
                      size: 2.2,
                      fontWeight: FontWeight.bold,
                    ),
                    BuildSizedBox(
                      height: 0.2,
                    ),
                    BuildText(
                      'Please enter the email that Admin has given to you or direcly requestto Admin for password reset',
                      size: 1.2,
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
                    BuildSecondaryButton(
                      onTap: () => controller.toLogin(),
                      label: 'Back to Login',
                      fontColor: AppColors.grey,
                      fontSize: 1,
                    ),
                    BuildSizedBox(
                      height: 3,
                    ),
                    BuildPrimaryButton(
                      onTap: () => controller.sendLink(),
                      label: 'Submit',
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

class ForgotpasswordMobile extends StatelessWidget {
  const ForgotpasswordMobile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ForgotpasswordController controller = Get.find();
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
            Center(
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BuildText(
                      'Forgot Password?',
                      size: 2.8,
                      fontWeight: FontWeight.bold,
                    ),
                    BuildSizedBox(
                      height: 0.5,
                    ),
                    BuildText(
                      'Please enter the email that Admin has given to you or direcly requestto Admin for password reset',
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
                          isDense: true),
                    ),
                    BuildSecondaryButton(
                      onTap: () => controller.toLogin(),
                      label: 'Back to Login',
                      fontColor: AppColors.grey,
                      fontSize: 2.5,
                    ),
                    BuildSizedBox(
                      height: 3,
                    ),
                    BuildPrimaryButton(
                      onTap: () => controller.sendLink(),
                      label: 'Submit',
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
