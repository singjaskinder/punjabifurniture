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
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'dashboard_controller.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => DashboardMobile(),
      desktop: (BuildContext context) => DashboardDesktop(),
    );
  }
}

class DashboardDesktop extends StatelessWidget {
  const DashboardDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();
    return Scaffold(
        backgroundColor: AppColors.transparent,
        body: Center(
          child: Container(
            width: SizeConfig.widthMultiplier * 110,
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: controller.watch(),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        if (snap.data!.docs.isEmpty) {
                          return BuildText(
                            'No Active orders found',
                            color: AppColors.brown,
                            fontWeight: FontWeight.bold,
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snap.data!.docs.length,
                          itemBuilder: (_, i) {
                            final order = OrderM.fromJson(snap.data!.docs[i]
                                .data() as Map<String, dynamic>);
                            return ExpansionTile(
                              backgroundColor: AppColors.white,
                              collapsedBackgroundColor: AppColors.white,
                              tilePadding: EdgeInsets.all(10),
                              childrenPadding: EdgeInsets.all(10),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BuildText('Added on:  ', size: 0.8),
                                        BuildText(makeDate(order.date!),
                                            size: 0.8,
                                            fontWeight: FontWeight.bold),
                                      ],
                                    ),
                                  ),
                                  BuildSizedBox(
                                    height: 0.4,
                                  ),
                                  Visibility(
                                    visible: controller.isAdmin,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BuildText(
                                          'Company name:',
                                          size: 0.8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        BuildText(
                                          order.company!,
                                          size: 1.4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BuildText(
                                            'Order Date:',
                                            size: 0.8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          BuildText(
                                            makeDate(order.orderDate!),
                                            size: 1.4,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BuildText(
                                            'Delivery Date:',
                                            size: 0.8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          BuildText(
                                            makeDate(order.deliveryDate!),
                                            size: 1.4,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BuildText(
                                            'Notes:',
                                            size: 0.8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          BuildText(
                                            controller
                                                    .getNotes(order)
                                                    .isNotEmpty
                                                ? controller.getNotes(order)
                                                : '-',
                                            size: 1.4,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BuildText('Order id: ', size: 0.8),
                                        BuildText(order.typeId!,
                                            size: 0.8,
                                            fontWeight: FontWeight.bold),
                                      ],
                                    ),
                                    Spacer(),
                                    BuildSecondaryButton(
                                      onTap: () => controller.showOrderDialog(
                                          true, order),
                                      label: 'View / Edit',
                                      fontSize: 1,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BuildText('Extra:', size: 0.8),
                                        BuildText(
                                            (controller.isAdmin
                                                        ? order.userNote!
                                                        : order.adminNote!)
                                                    .isEmpty
                                                ? ''
                                                : (controller.isAdmin
                                                    ? order.userNote!
                                                    : order.adminNote!),
                                            size: 1.4,
                                            fontWeight: FontWeight.bold),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
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
        ),
        floatingActionButton: controller.isAdmin
            ? BuildRoundedFloatingButton(
                onTap: () => controller.showOrderDialog(false, null),
                label: 'Add Order +',
              )
            : null);
  }
}

class DashboardMobile extends StatelessWidget {
  const DashboardMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();
    return Scaffold(
        backgroundColor: AppColors.transparent,
        body: Center(
          child: Container(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: controller.watch(),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        if (snap.data!.docs.isEmpty) {
                          return BuildText(
                            'No Active orders found',
                            color: AppColors.brown,
                            fontWeight: FontWeight.bold,
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snap.data!.docs.length,
                          itemBuilder: (_, i) {
                            final order = OrderM.fromJson(snap.data!.docs[i]
                                .data() as Map<String, dynamic>);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: ExpansionTile(
                                backgroundColor: AppColors.white,
                                collapsedBackgroundColor: AppColors.white,
                                tilePadding: EdgeInsets.all(10),
                                childrenPadding: EdgeInsets.all(10),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BuildText('Added on:  ', size: 1.5),
                                          BuildText(makeDate(order.date!),
                                              size: 1.5,
                                              fontWeight: FontWeight.bold),
                                        ],
                                      ),
                                    ),
                                    BuildSizedBox(
                                      height: 0.5,
                                    ),
                                    Visibility(
                                      visible: controller.isAdmin,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BuildText(
                                            'Company name:',
                                            size: 1.6,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          BuildText(
                                            order.company!,
                                            size: 2.2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BuildText(
                                              'Order Date:',
                                              size: 1.6,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            BuildText(
                                              makeDate(order.orderDate!),
                                              size: 2.2,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BuildText(
                                              'Delivery Date:',
                                              size: 1.6,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            BuildText(
                                              makeDate(order.deliveryDate!),
                                              size: 2.2,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BuildText(
                                          'Notes:',
                                          size: 1.6,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        BuildText(
                                          controller.getNotes(order).isNotEmpty
                                              ? controller.getNotes(order)
                                              : '-',
                                          size: 2.2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BuildText('Order id: ', size: 1.6),
                                          BuildText(order.typeId!,
                                              fontWeight: FontWeight.bold),
                                        ],
                                      ),
                                      Spacer(),
                                      BuildSecondaryButton(
                                        onTap: () => controller.showOrderDialog(
                                            true, order),
                                        label: 'View / Edit',
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildText('Extra:', size: 1.8),
                                      BuildText(
                                          (controller.isAdmin
                                                      ? order.userNote!
                                                      : order.adminNote!)
                                                  .isEmpty
                                              ? ''
                                              : (controller.isAdmin
                                                  ? order.userNote!
                                                  : order.adminNote!),
                                          size: 2.2,
                                          fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
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
        ),
        floatingActionButton: controller.isAdmin
            ? BuildRoundedFloatingButton(
                onTap: () => controller.showOrderDialog(false, null),
                label: 'Add Order +',
                fontSize: 2.4,
              )
            : null);
  }
}
