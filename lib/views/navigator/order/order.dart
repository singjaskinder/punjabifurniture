import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:punjabifurniture/common/build_circular_loading.dart';
import 'package:punjabifurniture/common/buttons.dart';
import 'package:punjabifurniture/common/sized_box.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/utils/local.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/res/app_styles.dart';
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'order_controller.dart';

class OrderV extends StatelessWidget {
  const OrderV({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => OrderVMobile(),
      desktop: (BuildContext context) => OrderVDesktop(),
    );
  }
}

class OrderVDesktop extends StatelessWidget {
  const OrderVDesktop({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.find();
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 5, color: AppColors.white)),
            child: BuildText(
              'create job'.toUpperCase(),
              size: 2.5,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BuildSizedBox(
          height: 2,
        ),
        SizedBox(
          width: SizeConfig.widthMultiplier * 100,
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BuildText(
                      'Job no.'.toUpperCase(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    BuildSizedBox(),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 72,
                      child: TextFormField(
                        enabled: controller.isAdmin,
                        controller: controller.typedIdCtrl,
                        cursorColor: AppColors.white,
                        style: AppStyles.primaryTextStyle
                            .copyWith(fontSize: 20, color: AppColors.white),
                        textInputAction: TextInputAction.done,
                        decoration: AppStyles.primaryTextFieldDecor.copyWith(
                            filled: true,
                            fillColor: AppColors.brown.withOpacity(0.1),
                            isDense: true),
                      ),
                    )
                  ],
                ),
                BuildSizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BuildText(
                      'Order Date'.toUpperCase(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    BuildSizedBox(),
                    Container(
                      width: SizeConfig.widthMultiplier * 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(width: 2, color: AppColors.white)),
                      child: GestureDetector(
                        onTap: () => controller.selectDate(true),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              BuildSizedBox(
                                width: 2,
                              ),
                              Obx(() => BuildText(
                                    controller.orderDate.value == 0
                                        ? 'Select'
                                        : makeDate(controller.orderDate.value),
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                    size: getValueForScreenType<double>(
                                      context: Get.context!,
                                      mobile: 2.6,
                                      desktop: 1.2,
                                    ),
                                  )),
                              Spacer(),
                              Icon(
                                Icons.calendar_today_rounded,
                                color: AppColors.white,
                                size: SizeConfig.imageSizeMultiplier * 3.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BuildSizedBox(
                      width: 3,
                    ),
                    BuildText(
                      'Delivery Date'.toUpperCase(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    BuildSizedBox(),
                    Container(
                      width: SizeConfig.widthMultiplier * 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(width: 2, color: AppColors.white)),
                      child: GestureDetector(
                        onTap: () => controller.selectDate(false),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              BuildSizedBox(
                                width: 2,
                              ),
                              Obx(() => BuildText(
                                    controller.deliveryDate.value == 0
                                        ? 'Select'
                                        : makeDate(
                                            controller.deliveryDate.value),
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                    size: getValueForScreenType<double>(
                                      context: Get.context!,
                                      mobile: 2.6,
                                      desktop: 1.2,
                                    ),
                                  )),
                              Spacer(),
                              Icon(
                                Icons.calendar_today_rounded,
                                color: AppColors.white,
                                size: SizeConfig.imageSizeMultiplier * 3.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BuildSizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BuildText(
                      'Assign User'.toUpperCase(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    BuildSizedBox(),
                    Obx(() => controller.gettingUser.value
                        ? Container(
                            width: SizeConfig.widthMultiplier * 72,
                            child: BuildCircularLoading())
                        : Container(
                            width: SizeConfig.widthMultiplier * 72,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: AppColors.white, width: 2)),
                            child: DropdownButton<String>(
                                isExpanded: true,
                                underline: const SizedBox(),
                                elevation: 0,
                                dropdownColor: AppColors.black.withOpacity(0.9),
                                hint: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: BuildText(
                                    'Select Company from the dropdown'
                                        .toUpperCase(),
                                    color: AppColors.white,
                                  ),
                                ),
                                icon: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.arrow_drop_down_sharp,
                                    color: AppColors.white,
                                  ),
                                ),
                                items: controller.users.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.name,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              SizeConfig.widthMultiplier * 1.5),
                                      child: BuildText(
                                        value.name!,
                                        color: AppColors.white,
                                        size: getValueForScreenType<double>(
                                            context: Get.context!,
                                            mobile: 2.4,
                                            desktop: 1.9),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                value: controller.selectedUser.value,
                                onChanged: (val) {
                                  controller.selectedUser.value = val!;
                                  controller.selectedUserId =
                                      controller.userWithIds[val]!;
                                }),
                          )),
                  ],
                ),
                BuildSizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BuildText(
                      'upload file'.toUpperCase(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    BuildSizedBox(),
                    Container(
                        padding: EdgeInsets.all(5),
                        width: SizeConfig.widthMultiplier * 72,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: AppColors.white, width: 2)),
                        child: Row(
                          children: [
                            BuildSizedBox(),
                            Obx(() => controller.filesNames.isEmpty
                                ? Container(
                                    child: BuildText(
                                      'ATTACH MULTIPLE PDF/PNG/JPG',
                                      color: AppColors.white,
                                      size: 1.5,
                                    ),
                                  )
                                : Container(
                                    width: SizeConfig.widthMultiplier * 65,
                                    height: SizeConfig.heightMultiplier * 2,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.filesNames.length,
                                        shrinkWrap: true,
                                        itemBuilder: (_, i) {
                                          return Container(
                                            margin: EdgeInsets.only(right: 4),
                                            decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(2),
                                            child: Row(
                                              children: [
                                                BuildSizedBox(
                                                  width: 0.5,
                                                ),
                                                BuildText(
                                                  controller.filesNames[i],
                                                  size: 1.4,
                                                ),
                                                BuildSizedBox(
                                                  width: 0.5,
                                                ),
                                                GestureDetector(
                                                  onTap: () =>
                                                      controller.removeFile(i),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: AppColors.black,
                                                    size: SizeConfig
                                                            .imageSizeMultiplier *
                                                        2.5,
                                                  ),
                                                ),
                                                BuildSizedBox(
                                                  width: 0.5,
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  )),
                            Spacer(),
                            GestureDetector(
                              onTap: () => controller.selectFile(),
                              child: Icon(
                                Icons.file_upload_outlined,
                                color: AppColors.white,
                                size: SizeConfig.imageSizeMultiplier * 3.5,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
                BuildSizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildText(
                      'Job Details'.toUpperCase(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    BuildSizedBox(),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 72,
                      child: TextFormField(
                        enabled: controller.isAdmin,
                        maxLines: 3,
                        controller: controller.jobDetailsCtrl,
                        cursorColor: AppColors.white,
                        style: AppStyles.primaryTextStyle
                            .copyWith(fontSize: 20, color: AppColors.white),
                        textInputAction: TextInputAction.done,
                        decoration: AppStyles.primaryTextFieldDecor.copyWith(
                            filled: true,
                            fillColor: AppColors.brown.withOpacity(0.1),
                            isDense: true),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        BuildSizedBox(
          height: 2,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              width: SizeConfig.widthMultiplier * 25,
              child: BuildWhiteButton(
                onTap: () => controller.auOrder(false, null),
                label: 'submit',
              )),
        ),
      ],
    );
  }
}

class OrderVMobile extends StatelessWidget {
  const OrderVMobile({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final OrderController controller = Get.find();
    return Column(
      children: [],
    );
  }
}
