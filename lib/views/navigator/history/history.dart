import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/common/build_circular_loading.dart';
import 'package:punjabifurniture/common/retry.dart';
import 'package:punjabifurniture/common/sized_box.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/models/order_m.dart';
import 'package:punjabifurniture/utils/local.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:punjabifurniture/views/navigator/users/users.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'history_controller.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HistoryController());
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => HistoryMobile(),
      desktop: (BuildContext context) => HistoryDesktop(),
    );
  }
}

class HistoryDesktop extends StatelessWidget {
  const HistoryDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.find();
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
            child: BuildText(
              'History',
              size: 2.5,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BuildSizedBox(),
        BuildText(
          'all jobs marked as received by admin will appear here'.toUpperCase(),
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
                      'No History found',
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
                          border: Border.all(width: 2, color: AppColors.white)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BuildListTitle(title: 'job no.', width: 14),
                          BuildListTitle(
                              title:
                                  controller.isAdmin ? 'company' : 'dispatch',
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
                          final order = OrderM.fromJson(snap.data!.docs[i]
                              .data() as Map<String, dynamic>);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              BuildListTitle(
                                  isHeading: false,
                                  title: order.status!,
                                  isCenter: true,
                                  width: 15),
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
    );
  }
}

class HistoryMobile extends StatelessWidget {
  const HistoryMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.find();
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: controller.watch(),
              builder: (_, snap) {
                if (snap.hasData) {
                  if (snap.data!.docs.isEmpty) {
                    return BuildText(
                      'No History found',
                      color: AppColors.brown,
                      fontWeight: FontWeight.bold,
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (_, i) {
                      final order = OrderM.fromJson(
                          snap.data!.docs[i].data() as Map<String, dynamic>);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BuildText('Added on:  ', size: 1.6),
                                    BuildText(makeDate(order.date!),
                                        size: 1.6, fontWeight: FontWeight.bold),
                                  ],
                                ),
                              ),
                              BuildSizedBox(
                                height: 0.5,
                              ),
                              Visibility(
                                visible: controller.isAdmin,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BuildText(
                                    'Notes:',
                                    size: 1.6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Container(
                                    width: SizeConfig.widthMultiplier * 30,
                                    child: BuildText(
                                      controller.isAdmin
                                          ? order.adminNote!
                                          : order.userNote!,
                                      overflow: TextOverflow.ellipsis,
                                      size: 2.2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BuildText('Order id: ', size: 1.6),
                                    BuildText(order.typeId!,
                                        size: 1.6, fontWeight: FontWeight.bold),
                                  ],
                                ),
                              ],
                            )
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
    );
  }
}
