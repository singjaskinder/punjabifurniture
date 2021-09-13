import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:punjabifurniture/common/sized_box.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/utils/local.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'buildnavigator_controller.dart';

class BuildNavigator extends StatelessWidget {
  const BuildNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BuildNavigatorController());
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => NavigationMobile(),
      desktop: (BuildContext context) => NavigationDesktop(),
    );
  }
}

class NavigationDesktop extends StatelessWidget {
  const NavigationDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BuildNavigatorController controller = Get.find();
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                getImage('back.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.widthMultiplier * 12, 25,
                SizeConfig.widthMultiplier * 12, 20),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      BuildSizedBox(),
                      Image.asset(
                        getImage('logo.png'),
                        width: SizeConfig.widthMultiplier * 40,
                        fit: BoxFit.cover,
                      ),
                      Spacer(),
                      Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: SizeConfig.imageSizeMultiplier * 7,
                      ),
                      BuildText(
                        controller.isAdmin ? 'Admin' : 'User',
                        size: 3.4,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      BuildSizedBox(
                        width: 3,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 4,
                  color: AppColors.white,
                ),
                BuildSizedBox(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.widthMultiplier * 25,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          for (int i = 0; i < controller.menus.length; i++)
                            Obx(
                              () => InkWell(
                                onTap: () => controller.selectedIndex.value = i,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: BuildText(
                                    controller.menus[i].label!,
                                    size: 1.8,
                                    fontWeight:
                                        controller.selectedIndex.value == i
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color: controller.selectedIndex.value == i
                                        ? AppColors.darkBrown
                                        : AppColors.black,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    BuildSizedBox(
                      width: 1.5,
                    ),
                    Expanded(
                        child: Obx(() => controller
                            .menus[controller.selectedIndex.value].view!))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NavigationMobile extends StatelessWidget {
  const NavigationMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BuildNavigatorController controller = Get.find();
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                getImage('back.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(30, 25, 30, 20),
                color: AppColors.darkerBrown.withOpacity(0.8),
                child: Row(
                  children: [
                    Spacer(),
                    Align(
                      alignment: Alignment.topCenter,
                      child: BuildText(
                        'Punjabi Furniture',
                        size: 5,
                        fontFamily: GoogleFonts.bebasNeue().fontFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                        color: AppColors.lighterBrown,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Divider(
                height: 4,
                color: AppColors.white,
              ),
              BuildSizedBox(),
              Expanded(
                  child: Obx(() =>
                      controller.menus[controller.selectedIndex.value].view!))
            ],
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.lighterBrown.withOpacity(0.2),
        height: SizeConfig.heightMultiplier * 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < controller.menus.length; i++)
              Expanded(
                child: Material(
                  color: AppColors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () => controller.selectedIndex.value = i,
                      borderRadius: BorderRadius.circular(10),
                      child: Obx(() => Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: controller.selectedIndex.value == i
                                    ? AppColors.brown
                                    : AppColors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: BuildText(
                              controller.menus[i].label!,
                              color: controller.selectedIndex.value == i
                                  ? AppColors.white
                                  : AppColors.lightBrown,
                              size: 2.5,
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            BuildSizedBox(
              width: 3,
            ),
          ],
        ),
      ),
    );
  }
}
