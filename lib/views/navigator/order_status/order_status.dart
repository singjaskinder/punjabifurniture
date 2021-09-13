import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/common/build_circular_loading.dart';
import 'package:punjabifurniture/common/buttons.dart';
import 'package:punjabifurniture/common/retry.dart';
import 'package:punjabifurniture/common/sized_box.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/models/order_m.dart';
import 'package:punjabifurniture/utils/local.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/res/app_styles.dart';
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:punjabifurniture/views/navigator/users/users.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'order_status_controller.dart';

class OrderStatus extends StatelessWidget {
  const OrderStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OrderStatusController());
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => OrderStatusMobile(),
      desktop: (BuildContext context) => OrderStatusDesktop(),
    );
  }
}

class OrderStatusDesktop extends StatelessWidget {
  const OrderStatusDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderStatusController controller = Get.find();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 5, color: AppColors.white)),
            child: Obx(
              () => BuildText(
                (controller.showDetails.value ? 'job details' : 'All Jobs')
                    .toUpperCase(),
                size: 2.5,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        BuildSizedBox(),
        Obx(
          () => Visibility(
            visible: controller.showDetails.value,
            child: SizedBox(
              width: SizeConfig.widthMultiplier * 105,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildBackButton(onTap: () => controller.clearData()),
                    BuildSizedBox(),
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
                            decoration: AppStyles.primaryTextFieldDecor
                                .copyWith(
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
                              border:
                                  Border.all(width: 2, color: AppColors.white)),
                          child: GestureDetector(
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
                                            : makeDate(
                                                controller.orderDate.value),
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
                              border:
                                  Border.all(width: 2, color: AppColors.white)),
                          child: GestureDetector(
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
                          'User'.toUpperCase(),
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        BuildSizedBox(),
                        Container(
                            padding: EdgeInsets.all(6),
                            width: SizeConfig.widthMultiplier * 72,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    width: 2, color: AppColors.white)),
                            child: BuildText(
                              controller.selectedUser.value,
                              color: AppColors.white,
                              size: 1.6,
                            ))
                      ],
                    ),
                    BuildSizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BuildText(
                          'uploaded file'.toUpperCase(),
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          size: 2,
                        ),
                        BuildSizedBox(),
                        Container(
                            padding: EdgeInsets.all(5),
                            width: SizeConfig.widthMultiplier * 72,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: AppColors.white, width: 2)),
                            child: Row(
                              children: [
                                BuildSizedBox(),
                                Obx(() => controller.filesNames.isEmpty
                                    ? Container(
                                        child: BuildText(
                                          'No files attached'.toUpperCase(),
                                          color: AppColors.white,
                                          size: 1.5,
                                        ),
                                      )
                                    : Container(
                                        width: SizeConfig.widthMultiplier * 20,
                                        child: ListView.builder(
                                            itemCount:
                                                controller.filesNames.length,
                                            shrinkWrap: true,
                                            itemBuilder: (_, i) {
                                              return InkWell(
                                                onTap: () =>
                                                    controller.openFile(i),
                                                child: Container(
                                                  margin: EdgeInsets.all(2),
                                                  padding: EdgeInsets.all(2),
                                                  child: Row(
                                                    children: [
                                                      BuildText(
                                                        controller
                                                            .filesNames[i],
                                                        size: 1.4,
                                                        color: AppColors.white,
                                                      ),
                                                      BuildSizedBox(
                                                        width: 0.5,
                                                      ),
                                                      Icon(
                                                        Icons.download,
                                                        color: AppColors.white,
                                                        size: SizeConfig
                                                                .imageSizeMultiplier *
                                                            2.5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      )),
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
                            decoration: AppStyles.primaryTextFieldDecor
                                .copyWith(
                                    filled: true,
                                    fillColor: AppColors.brown.withOpacity(0.1),
                                    isDense: true),
                          ),
                        )
                      ],
                    ),
                    BuildSizedBox(
                      height: 2,
                    ),
                    Visibility(
                      visible: controller.isAdmin,
                      child: Row(
                        children: [
                          // Spacer(),
                          // Container(
                          //     width: SizeConfig.widthMultiplier * 25,
                          //     child: BuildWhiteButton(
                          //       onTap: () =>
                          //           controller.auOrder(true, controller.order),
                          //       label: 'submit',
                          //     )),
                          // Spacer(),
                          Container(
                              width: SizeConfig.widthMultiplier * 35,
                              child: BuildWhiteButton(
                                onTap: () {
                                  controller.selectedStatus.value = 'Received';
                                  controller.auOrder(true, controller.order);
                                },
                                label: 'Marked as received',
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => Visibility(
            visible: !controller.showDetails.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildText('click job no. for job details'.toUpperCase(),
                    color: AppColors.white, size: 1),
                BuildSizedBox(),
                StreamBuilder<QuerySnapshot>(
                    stream: controller.watch(),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        if (snap.data!.docs.isEmpty) {
                          return Center(
                            child: BuildText(
                              'No Active Jobs found',
                              size: 1.4,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 2, color: AppColors.white)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BuildListTitle(title: 'job no.', width: 14),
                                  BuildListTitle(
                                      title: controller.isAdmin
                                          ? 'company'
                                          : 'dispatch',
                                      width: 15),
                                  BuildListTitle(
                                    title: 'status',
                                    width: 20,
                                    isCenter: true,
                                  ),
                                  BuildListTitle(
                                      title: controller.isAdmin
                                          ? 'delivery date'
                                          : 'received date',
                                      width: 20),
                                  BuildListTitle(title: 'notes', width: 30),
                                ],
                              ),
                            ),
                            BuildSizedBox(
                              height: 0.5,
                            ),
                            Container(
                              height: SizeConfig.heightMultiplier * 32,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snap.data!.docs.length,
                                itemBuilder: (_, i) {
                                  final order = OrderM.fromJson(
                                      snap.data!.docs[i].data()
                                          as Map<String, dynamic>);
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () =>
                                            controller.showJobDetails(order),
                                        child: BuildListTitle(
                                            isHeading: false,
                                            title: order.typeId!,
                                            width: 14),
                                      ),
                                      BuildListTitle(
                                          isHeading: false,
                                          title: controller.isAdmin
                                              ? order.company!
                                              : makeDate(order.orderDate!),
                                          width: 20),
                                      Container(
                                        width: SizeConfig.widthMultiplier * 20,
                                        child: Row(
                                          children: [
                                            PopupMenuButton(
                                              tooltip:
                                                  'Click to change job status',
                                              color: AppColors.black,
                                              child: Center(
                                                child: BuildText(
                                                  order.status!.toUpperCase(),
                                                  color: AppColors.white,
                                                  size: 1.2,
                                                ),
                                              ),
                                              itemBuilder: (context) {
                                                return List.generate(
                                                    controller.actions.length,
                                                    (index) {
                                                  return PopupMenuItem(
                                                    value: index,
                                                    child: BuildText(
                                                      controller.actions[index],
                                                      color: AppColors.white,
                                                      size: 1,
                                                    ),
                                                  );
                                                });
                                              },
                                              onSelected: (v) {
                                                order.status = controller
                                                    .actions[v as int];
                                                controller.updateStatus(order);
                                              },
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down_sharp,
                                              color: AppColors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                      BuildListTitle(
                                          isHeading: false,
                                          title: makeDate(order.deliveryDate!),
                                          isCenter: true,
                                          width: 20),
                                      BuildListTitle(
                                          isHeading: false,
                                          title: order.jobDetails!,
                                          width: 30),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (snap.hasError) {
                        print(snap.error);
                        return BuildRetry(onRetry: () {});
                      } else {
                        return BuildCircularLoading();
                      }
                    })
              ],
            ),
          ),
        )
      ],
    );
  }
}

class OrderStatusMobile extends StatelessWidget {
  const OrderStatusMobile({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final OrderStatusController controller = Get.find();
    return Column(
      children: [],
    );
  }
}
