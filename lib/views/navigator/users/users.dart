import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/common/build_circular_loading.dart';
import 'package:punjabifurniture/common/buttons.dart';
import 'package:punjabifurniture/common/retry.dart';
import 'package:punjabifurniture/common/sized_box.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/models/user_m.dart';
import 'package:punjabifurniture/utils/local.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'users_controller.dart';

class Users extends StatelessWidget {
  const Users({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UsersController());
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => UsersMobile(),
      desktop: (BuildContext context) => UsersDesktop(),
    );
  }
}

class UsersDesktop extends StatelessWidget {
  const UsersDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UsersController controller = Get.find();
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
                          'No User added',
                          color: AppColors.brown,
                          fontWeight: FontWeight.bold,
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snap.data!.docs.length,
                        itemBuilder: (_, i) {
                          final user = UserM.fromJson(snap.data!.docs[i].data()
                              as Map<String, dynamic>);
                          return ExpansionTile(
                            backgroundColor: AppColors.white,
                            collapsedBackgroundColor: AppColors.white,
                            tilePadding: EdgeInsets.all(10),
                            childrenPadding: EdgeInsets.all(10),
                            title: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildText('Added on:  ', size: 0.8),
                                      BuildText(makeDate(user.date!),
                                          size: 0.8,
                                          fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                                BuildSizedBox(
                                  height: 0.4,
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
                                          'Company:',
                                          size: 0.8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        BuildText(
                                          user.company!.capitalizeFirst!,
                                          size: 1.4,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BuildText(
                                          'User Name:',
                                          size: 0.8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        BuildText(
                                          user.name!.capitalizeFirst!,
                                          size: 1.4,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BuildText(
                                          'Phone:',
                                          size: 0.8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        BuildText(
                                          user.phone!,
                                          size: 1.4,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BuildText(
                                          'Status:',
                                          size: 0.8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        BuildText(
                                          user.status!.capitalizeFirst!,
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
                                      BuildText('#id: ', size: 0.8),
                                      BuildText(user.id!,
                                          size: 0.8,
                                          fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                  Spacer(),
                                  BuildSecondaryButton(
                                    onTap: () =>
                                        controller.showUserDialog(true, user),
                                    label: 'View  / Edit',
                                    fontSize: 1,
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    } else if (snap.hasError) {
                      return BuildRetry(onRetry: () {});
                    } else {
                      return BuildCircularLoading();
                    }
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: BuildRoundedFloatingButton(
        onTap: () => controller.showUserDialog(false, null),
        label: 'Add User +',
      ),
    );
  }
}

class UsersMobile extends StatelessWidget {
  const UsersMobile({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final UsersController controller = Get.find();
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
                      'No User added',
                      color: AppColors.brown,
                      fontWeight: FontWeight.bold,
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (_, i) {
                      final user = UserM.fromJson(
                          snap.data!.docs[i].data() as Map<String, dynamic>);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ExpansionTile(
                          backgroundColor: AppColors.white,
                          collapsedBackgroundColor: AppColors.white,
                          tilePadding: EdgeInsets.all(10),
                          childrenPadding: EdgeInsets.all(10),
                          title: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BuildText('Added on:  ', size: 1.5),
                                    BuildText(makeDate(user.date!),
                                        size: 1.5, fontWeight: FontWeight.bold),
                                  ],
                                ),
                              ),
                              BuildSizedBox(
                                height: 0.5,
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
                                        'Company:',
                                        size: 1.6,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      BuildText(
                                        user.company!.capitalizeFirst!,
                                        size: 2.2,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildText(
                                        'User Name:',
                                        size: 1.6,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      BuildText(
                                        user.name!.capitalizeFirst!,
                                        size: 2.2,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildText(
                                        'Phone:',
                                        size: 1.6,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      BuildText(
                                        user.phone!,
                                        size: 2.2,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BuildText('#id: ', size: 2),
                                    BuildText(user.id!,
                                        size: 1.5, fontWeight: FontWeight.bold),
                                  ],
                                ),
                                BuildSizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BuildText(
                                      'Status:',
                                      size: 1.6,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    BuildText(
                                      user.status!.capitalizeFirst!,
                                      size: 2.4,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                BuildSecondaryButton(
                                  onTap: () =>
                                      controller.showUserDialog(true, user),
                                  label: 'View  / Edit',
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else if (snap.hasError) {
                  return BuildRetry(onRetry: () {});
                } else {
                  return BuildCircularLoading();
                }
              })
        ],
      ),
      floatingActionButton: BuildRoundedFloatingButton(
        onTap: () => controller.showUserDialog(false, null),
        label: 'Add User +',
        fontSize: 2.4,
      ),
    );
  }
}
