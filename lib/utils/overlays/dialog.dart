import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/common/buttons.dart';
import 'package:punjabifurniture/common/sized_box.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../size_config.dart';

class BuildDialog {
  BuildDialog(
      {String? title,
      String? description,
      String? posLabel,
      String? negLabel,
      Function? onPos,
      Function? onNeg,
      bool continueTask = false}) {
    Get.dialog(
        Scaffold(
            backgroundColor: AppColors.transparent,
            body: Center(
              child: Container(
                width: SizeConfig.widthMultiplier *
                    getValueForScreenType<double>(
                      context: Get.context!,
                      mobile: 80,
                      desktop: 60,
                    ),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildText(
                      title ?? 'Oops',
                      color: AppColors.brown,
                      fontWeight: FontWeight.bold,
                      size: getValueForScreenType<double>(
                        context: Get.context!,
                        mobile: 3,
                        desktop: 2.17,
                      ),
                    ),
                    BuildSizedBox(
                      height: 2,
                    ),
                    BuildText(
                      description ?? 'Something went wrong ...',
                      size: getValueForScreenType<double>(
                        context: Get.context!,
                        mobile: 2.2,
                        desktop: 1.5,
                      ),
                      color: AppColors.black,
                    ),
                    BuildSizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                            visible: negLabel != null,
                            child: Expanded(
                              child: BuildSecondaryButton(
                                onTap: () =>
                                    onNeg == null ? Get.back() : onNeg(),
                                label: negLabel ?? '',
                                verticalPadding: 10,
                                fontSize: getValueForScreenType<double>(
                                  context: Get.context!,
                                  mobile: 2.5,
                                  desktop: 1.8,
                                ),
                              ),
                            )),
                        BuildSizedBox(),
                        Expanded(
                          child: BuildSecondaryButton(
                            onTap: () {
                              if (onPos == null) {
                                Get.back();
                              } else {
                                if (continueTask) {
                                  Get.back();
                                }
                                onPos();
                              }
                            },
                            label: posLabel ?? 'OK',
                            verticalPadding: 10,
                            fontSize: getValueForScreenType<double>(
                              context: Get.context!,
                              mobile: 2.5,
                              desktop: 1.8,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
        barrierDismissible: false);
  }
}
