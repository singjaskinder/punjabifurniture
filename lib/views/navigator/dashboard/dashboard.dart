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
    return Column(
      children: [
        Visibility(
          visible: controller.isAdmin,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  child: BuildText(
                    'Search Order',
                    size: 2.5,
                    color: AppColors.white,
                  ),
                ),
              ),
              BuildSizedBox(
                height: 0.6,
              ),
              Visibility(
                visible: controller.isAdmin,
                child: SizedBox(
                  width: SizeConfig.widthMultiplier * 60,
                  child: TextFormField(
                    controller: controller.searchCtrl,
                    textAlign: TextAlign.center,
                    cursorColor: AppColors.white,
                    style: AppStyles.primaryTextStyle
                        .copyWith(fontSize: 25, color: AppColors.white),
                    textInputAction: TextInputAction.done,
                    decoration: AppStyles.primaryTextFieldDecor.copyWith(
                        contentPadding: EdgeInsets.all(20),
                        hintText: 'Enter Job Number Here',
                        hintStyle:
                            TextStyle(fontSize: 25, color: AppColors.grey),
                        filled: true,
                        fillColor: AppColors.brown.withOpacity(0.1),
                        isDense: true),
                  ),
                ),
              ),
              BuildSizedBox(),
              Obx(
                () => controller.searchText.value.isEmpty
                    ? SizedBox()
                    : GetBuilder<DashboardController>(
                        builder: (_) {
                          return StreamBuilder<QuerySnapshot>(
                              stream: controller.watch(),
                              builder: (_, snap) {
                                if (snap.hasData) {
                                  if (snap.data!.docs.isEmpty) {
                                    return Center(
                                      child: BuildText(
                                        'No Active Jobs found',
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 2,
                                                color: AppColors.white)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            BuildListTitle(
                                                title: 'job no.', width: 14),
                                            BuildListTitle(
                                                title: controller.isAdmin
                                                    ? 'company'
                                                    : 'dispatch',
                                                width: 20),
                                            BuildListTitle(
                                              title: 'status',
                                              width: 15,
                                              isCenter: true,
                                            ),
                                            BuildListTitle(
                                                title: controller.isAdmin
                                                    ? 'delivery date'
                                                    : 'received date',
                                                width: 20),
                                            BuildListTitle(
                                                title: 'notes', width: 30),
                                          ],
                                        ),
                                      ),
                                      BuildSizedBox(
                                        height: 0.5,
                                      ),
                                      Container(
                                        height:
                                            SizeConfig.heightMultiplier * 30,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snap.data!.docs.length,
                                          itemBuilder: (_, i) {
                                            final order = OrderM.fromJson(
                                                snap.data!.docs[i].data()
                                                    as Map<String, dynamic>);
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                BuildListTitle(
                                                    isHeading: false,
                                                    title: order.typeId!,
                                                    width: 14),
                                                BuildListTitle(
                                                    isHeading: false,
                                                    title: controller.isAdmin
                                                        ? order.company!
                                                        : makeDate(
                                                            order.orderDate!),
                                                    width: 20),
                                                BuildListTitle(
                                                    isHeading: false,
                                                    title: order.status!,
                                                    isCenter: true,
                                                    width: 15),
                                                BuildListTitle(
                                                    isHeading: false,
                                                    title: makeDate(
                                                        order.deliveryDate!),
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
                              });
                        },
                      ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: !controller.isAdmin,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 5, color: AppColors.white)),
                  child: BuildText(
                    'Dashboard'.toUpperCase(),
                    size: 2.5,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BuildSizedBox(),
              BuildText(
                'list of new jobs created'.toUpperCase(),
                color: AppColors.white,
                size: 1,
              ),
              BuildSizedBox(),
              StreamBuilder<QuerySnapshot>(
                  stream: controller.watch(),
                  builder: (_, snap) {
                    if (snap.hasData) {
                      if (snap.data!.docs.isEmpty) {
                        return Center(
                          child: BuildText(
                            'No Active Jobs found',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BuildListTitle(title: 'job no.', width: 14),
                                BuildListTitle(
                                    title: controller.isAdmin
                                        ? 'company'
                                        : 'dispatch',
                                    width: 20),
                                BuildListTitle(
                                  title: 'status',
                                  width: 15,
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
                            height: SizeConfig.heightMultiplier * 30,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snap.data!.docs.length,
                              itemBuilder: (_, i) {
                                final order = OrderM.fromJson(snap.data!.docs[i]
                                    .data() as Map<String, dynamic>);
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BuildListTitle(
                                        isHeading: false,
                                        title: order.typeId!,
                                        width: 14),
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
                                              order.status =
                                                  controller.actions[v as int];
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
      ],
    );
  }
}

class DashboardMobile extends StatelessWidget {
  const DashboardMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();
    return Scaffold(
        backgroundColor: AppColors.transparent,
        body: Column(
          children: [
            Visibility(
              visible: controller.isAdmin,
              child: Container(
                color: AppColors.white,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: controller.searchCtrl,
                        style:
                            AppStyles.primaryTextStyle.copyWith(fontSize: 18),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Search order by order id or job no.',
                          filled: true,
                          fillColor: AppColors.brown.withOpacity(0.1),
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BuildSizedBox(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: controller.watch(),
                  builder: (_, snap) {
                    if (snap.hasData) {
                      if (snap.data!.docs.isEmpty) {
                        return Center(
                          child: BuildText(
                            'No Active Jobs found',
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
                                          BuildText('#' + order.typeId!,
                                              size: 1.5,
                                              fontWeight: FontWeight.bold),
                                          Spacer(),
                                          BuildText(makeDate(order.date!),
                                              size: 1.5,
                                              fontWeight: FontWeight.bold),
                                        ],
                                      ),
                                    ),
                                    BuildSizedBox(),
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
                                            order.company!.capitalize!,
                                            size: 2.4,
                                          ),
                                          BuildSizedBox(),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width:
                                              SizeConfig.widthMultiplier * 25,
                                          child: Column(
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
                                        ),
                                        Container(
                                          width:
                                              SizeConfig.widthMultiplier * 25,
                                          child: Column(
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
                                        ),
                                        Container(
                                          width:
                                              SizeConfig.widthMultiplier * 25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              BuildText(
                                                'Status:',
                                                size: 1.6,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              BuildText(
                                                order.status!,
                                                size: 2.2,
                                              ),
                                            ],
                                          ),
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
                                      Spacer(),
                                      BuildSecondaryButton(
                                        onTap: () => controller.showOrderDialog(
                                            true, order),
                                        label: 'View / Edit',
                                        fontSize: 2.6,
                                      ),
                                    ],
                                  ),
                                  BuildText(
                                    'Admin Notes:',
                                    size: 1.6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  BuildText(
                                    order.adminNote!.isEmpty
                                        ? '-'
                                        : order.adminNote!,
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                    size: 2.4,
                                  ),
                                  BuildSizedBox(),
                                  BuildText(
                                    'User Notes:',
                                    size: 1.6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  BuildText(
                                    order.userNote!.isEmpty
                                        ? '-'
                                        : order.userNote!,
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                    size: 2.4,
                                  ),
                                  BuildSizedBox(),
                                  BuildText(
                                    'Job Details:',
                                    size: 1.6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  BuildText(
                                    order.jobDetails!.isEmpty
                                        ? '-'
                                        : order.jobDetails!,
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                    size: 2.4,
                                  ),
                                ],
                              ));
                        },
                      );
                    } else if (snap.hasError) {
                      print(snap.error);
                      return BuildRetry(onRetry: () {});
                    } else {
                      return BuildCircularLoading();
                    }
                  }),
            ),
          ],
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
