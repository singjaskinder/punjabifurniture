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
                            style: AppStyles.primaryTextStyle
                                .copyWith(fontSize: 18),
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
                BuildSizedBox(
                  height: 0.8,
                ),
                Expanded(
                  child: GetBuilder<DashboardController>(
                    builder: (_) {
                      return StreamBuilder<QuerySnapshot>(
                          stream: controller.watch(),
                          builder: (_, snap) {
                            if (snap.hasData) {
                              if (snap.data!.docs.isEmpty) {
                                return Center(
                                  child: BuildText(
                                    'No Active orders found',
                                    color: AppColors.brown,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snap.data!.docs.length,
                                itemBuilder: (_, i) {
                                  final order = OrderM.fromJson(
                                      snap.data!.docs[i].data()
                                          as Map<String, dynamic>);
                                  return ExpansionTile(
                                    backgroundColor: AppColors.white,
                                    collapsedBackgroundColor: AppColors.white,
                                    tilePadding: EdgeInsets.all(10),
                                    childrenPadding: EdgeInsets.all(10),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              BuildText('#' + order.typeId!,
                                                  size: 1,
                                                  fontWeight: FontWeight.bold),
                                              Spacer(),
                                              BuildText('Added on:  ',
                                                  size: 0.8),
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
                                                order.company!.capitalize!,
                                                size: 1.4,
                                              ),
                                              BuildSizedBox(
                                                height: 0.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      25,
                                              child: Column(
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
                                            ),
                                            Container(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      25,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  BuildText(
                                                    'Delivery Date:',
                                                    size: 0.8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  BuildText(
                                                    makeDate(
                                                        order.deliveryDate!),
                                                    size: 1.4,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      25,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  BuildText(
                                                    'Status:',
                                                    size: 0.8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .lightBrown
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .darkerBrown,
                                                            width: 0.5)),
                                                    child: DropdownButton<
                                                            String>(
                                                        isExpanded: true,
                                                        underline:
                                                            const SizedBox(),
                                                        elevation: 0,
                                                        hint: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0),
                                                          child:
                                                              const BuildText(
                                                            'Select Status',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        icon: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10.0),
                                                          child: Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color:
                                                                AppColors.brown,
                                                          ),
                                                        ),
                                                        items: controller
                                                            .actions
                                                            .map(
                                                                (String value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: SizeConfig
                                                                          .widthMultiplier *
                                                                      1.5),
                                                              child: BuildText(
                                                                value,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .darkerBrown,
                                                                size:
                                                                    getValueForScreenType<
                                                                        double>(
                                                                  context: Get
                                                                      .context!,
                                                                  mobile: 2.4,
                                                                  desktop: 1.2,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        value: order.status,
                                                        onChanged: (val) {
                                                          order.status = val;
                                                          order.completed =
                                                              val == 'Received';
                                                          controller
                                                              .updateStatus(
                                                                  order);
                                                        }),
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
                                            onTap: () => controller
                                                .showOrderDialog(true, order),
                                            label: 'View / Edit',
                                            fontSize: 1,
                                          ),
                                        ],
                                      ),
                                      BuildText(
                                        'Admin Notes:',
                                        size: 0.8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      BuildText(
                                        order.adminNote!.isEmpty
                                            ? '-'
                                            : order.adminNote!,
                                        maxLines: 6,
                                        overflow: TextOverflow.ellipsis,
                                        size: 1.2,
                                      ),
                                      BuildSizedBox(),
                                      BuildText(
                                        'User Notes:',
                                        size: 0.8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      BuildText(
                                        order.userNote!.isEmpty
                                            ? '-'
                                            : order.userNote!,
                                        maxLines: 6,
                                        overflow: TextOverflow.ellipsis,
                                        size: 1.2,
                                      ),
                                      BuildSizedBox(),
                                      BuildText(
                                        'Job Details:',
                                        size: 0.8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      BuildText(
                                        order.jobDetails!.isEmpty
                                            ? '-'
                                            : order.jobDetails!,
                                        maxLines: 6,
                                        overflow: TextOverflow.ellipsis,
                                        size: 1.2,
                                      ),
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
                          });
                    },
                  ),
                ),
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
                            'No Active orders found',
                            color: AppColors.brown,
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
