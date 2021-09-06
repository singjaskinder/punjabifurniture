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
          Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(30, 25, 30, 20),
                color: AppColors.darkerBrown.withOpacity(0.8),
                child: Row(
                  children: [
                    BuildSizedBox(
                      width: 4,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: BuildText(
                        'Punjabi Furniture',
                        size: 4,
                        fontFamily: GoogleFonts.bebasNeue().fontFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                        color: AppColors.lighterBrown,
                      ),
                    ),
                    Spacer(),
                    for (int i = 0; i < controller.menus.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Material(
                          color: AppColors.transparent,
                          child: InkWell(
                            onTap: () => controller.selectedIndex.value = i,
                            borderRadius: BorderRadius.circular(10),
                            child: Obx(() => Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: controller.selectedIndex.value == i
                                          ? AppColors.lightBrown
                                              .withOpacity(0.5)
                                          : AppColors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: BuildText(
                                    controller.menus[i].label!,
                                    color: controller.selectedIndex.value == i
                                        ? AppColors.white
                                        : AppColors.lightBrown,
                                    size: 1.65,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    BuildSizedBox(
                      width: 3,
                    ),
                    GestureDetector(
                      onTap: () => controller.toLogout(),
                      child: Icon(
                        Icons.logout,
                        color: AppColors.lighterBrown,
                        size: SizeConfig.imageSizeMultiplier * 4,
                      ),
                    ),
                    BuildSizedBox(
                      width: 4,
                    ),
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
    );
  }
}

class NavigationMobile extends StatelessWidget {
  const NavigationMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BuildNavigatorController controller = Get.find();
    return Scaffold(
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
                    GestureDetector(
                      onTap: () => controller.toLogout(),
                      child: Icon(
                        Icons.logout,
                        color: AppColors.lighterBrown,
                        size: SizeConfig.imageSizeMultiplier * 4,
                      ),
                    ),
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
