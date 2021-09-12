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
import 'package:punjabifurniture/utils/res/app_styles.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Obx(
              () => Visibility(
                visible: controller.viewType.value != ViewType.manageAction,
                child: BuildBackButton(
                    onTap: () =>
                        controller.viewType.value = ViewType.manageAction),
              ),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 5, color: AppColors.white)),
              child: Obx(
                () => BuildText(
                  controller.viewTitle().toUpperCase(),
                  size: 2.5,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer()
          ],
        ),
        BuildSizedBox(
          height: 1.5,
        ),
        Obx(
          () => Visibility(
            visible: controller.viewType.value == ViewType.manageAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () => controller.viewType.value = ViewType.addUser,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: BuildText(
                          'CREATE NEW USER',
                          size: 2.5,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () =>
                          controller.viewType.value = ViewType.manageUser,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: BuildText(
                          'MANAGE USER',
                          size: 2.5,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
        Obx(
          () => Visibility(
              visible: controller.viewType.value == ViewType.addUser,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BuildText(
                                    'Company'.toUpperCase(),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                  BuildSizedBox(),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 50,
                                    child: TextFormField(
                                      controller: controller.companyCtrl,
                                      cursorColor: AppColors.white,
                                      style: AppStyles.primaryTextStyle
                                          .copyWith(
                                              fontSize: 20,
                                              color: AppColors.white),
                                      textInputAction: TextInputAction.done,
                                      decoration: AppStyles
                                          .primaryTextFieldDecor
                                          .copyWith(
                                              filled: true,
                                              fillColor: AppColors.brown
                                                  .withOpacity(0.1),
                                              isDense: true),
                                      validator: (val) => val!.isNotEmpty
                                          ? null
                                          : 'Please enter company name',
                                    ),
                                  )
                                ],
                              ),
                              BuildSizedBox(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BuildText(
                                    'Email'.toUpperCase(),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                  BuildSizedBox(),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 50,
                                    child: TextFormField(
                                      controller: controller.emailCtrl,
                                      cursorColor: AppColors.white,
                                      style: AppStyles.primaryTextStyle
                                          .copyWith(
                                              fontSize: 20,
                                              color: AppColors.white),
                                      textInputAction: TextInputAction.done,
                                      decoration: AppStyles
                                          .primaryTextFieldDecor
                                          .copyWith(
                                              filled: true,
                                              fillColor: AppColors.brown
                                                  .withOpacity(0.1),
                                              isDense: true),
                                      validator: (val) => val!.isEmail
                                          ? null
                                          : 'Please enter valid email',
                                    ),
                                  )
                                ],
                              ),
                              BuildSizedBox(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BuildText(
                                    'Phone'.toUpperCase(),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                  BuildSizedBox(),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 50,
                                    child: TextFormField(
                                      controller: controller.phoneCtrl,
                                      cursorColor: AppColors.white,
                                      style: AppStyles.primaryTextStyle
                                          .copyWith(
                                              fontSize: 20,
                                              color: AppColors.white),
                                      textInputAction: TextInputAction.done,
                                      decoration: AppStyles
                                          .primaryTextFieldDecor
                                          .copyWith(
                                              filled: true,
                                              fillColor: AppColors.brown
                                                  .withOpacity(0.1),
                                              isDense: true),
                                      validator: (val) => val!.isNum &&
                                              val.length == 10
                                          ? null
                                          : 'Please enter valid phone number',
                                    ),
                                  )
                                ],
                              ),
                              BuildSizedBox(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BuildText(
                                    'Address'.toUpperCase(),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                  BuildSizedBox(),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 50,
                                    child: TextFormField(
                                      controller: controller.addressCtrl,
                                      cursorColor: AppColors.white,
                                      style: AppStyles.primaryTextStyle
                                          .copyWith(
                                              fontSize: 20,
                                              color: AppColors.white),
                                      textInputAction: TextInputAction.done,
                                      decoration: AppStyles
                                          .primaryTextFieldDecor
                                          .copyWith(
                                              filled: true,
                                              fillColor: AppColors.brown
                                                  .withOpacity(0.1),
                                              isDense: true),
                                      validator: (val) => val!.isNotEmpty
                                          ? null
                                          : 'Please enter valid address',
                                    ),
                                  )
                                ],
                              ),
                              BuildSizedBox(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BuildText(
                                    'Username'.toUpperCase(),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                  BuildSizedBox(),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 50,
                                    child: TextFormField(
                                      controller: controller.nameCtrl,
                                      cursorColor: AppColors.white,
                                      style: AppStyles.primaryTextStyle
                                          .copyWith(
                                              fontSize: 20,
                                              color: AppColors.white),
                                      textInputAction: TextInputAction.done,
                                      decoration: AppStyles
                                          .primaryTextFieldDecor
                                          .copyWith(
                                              filled: true,
                                              fillColor: AppColors.brown
                                                  .withOpacity(0.1),
                                              isDense: true),
                                      validator: (val) => val!.isNotEmpty
                                          ? null
                                          : 'Please enter valid username',
                                    ),
                                  )
                                ],
                              ),
                              BuildSizedBox(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BuildText(
                                    'Password'.toUpperCase(),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                  BuildSizedBox(),
                                  SizedBox(
                                    width: SizeConfig.widthMultiplier * 50,
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: controller.passwordCtrl,
                                      cursorColor: AppColors.white,
                                      style: AppStyles.primaryTextStyle
                                          .copyWith(
                                              fontSize: 20,
                                              color: AppColors.white),
                                      textInputAction: TextInputAction.done,
                                      decoration: AppStyles
                                          .primaryTextFieldDecor
                                          .copyWith(
                                              filled: true,
                                              fillColor: AppColors.brown
                                                  .withOpacity(0.1),
                                              isDense: true),
                                      validator: (val) => val!.isNotEmpty
                                          ? null
                                          : 'Please enter valid password',
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                  BuildSizedBox(
                    height: 2,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        width: SizeConfig.widthMultiplier * 25,
                        child: BuildWhiteButton(
                          onTap: () => controller.auUser(false, null),
                          label: 'submit',
                        )),
                  ),
                ],
              )),
        ),
        Obx(
          () => Visibility(
              visible: controller.viewType.value == ViewType.manageUser,
              child: StreamBuilder<QuerySnapshot>(
                  stream: controller.watch(),
                  builder: (_, snap) {
                    if (snap.hasData) {
                      if (snap.data!.docs.isEmpty) {
                        return Center(
                          child: BuildText(
                            'No User added',
                            color: AppColors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BuildListTitle(
                                          title: 'company', width: 15),
                                      BuildListTitle(title: 'email', width: 15),
                                      BuildListTitle(title: 'phone', width: 15),
                                      BuildListTitle(
                                          title: 'address', width: 15),
                                      BuildListTitle(title: 'user', width: 15),
                                      BuildListTitle(
                                          title: 'password', width: 15),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                  maintainState: true,
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainSemantics: true,
                                  child: Row(
                                    children: [
                                      BuildSizedBox(
                                        width: 2,
                                      ),
                                      BuildWhiteButton(
                                          onTap: () => {}, label: 'view / edit')
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: snap.data!.docs.length,
                            separatorBuilder: (_, i) {
                              return BuildSizedBox(
                                height: 0.6,
                              );
                            },
                            itemBuilder: (_, i) {
                              final user = UserM.fromJson(snap.data!.docs[i]
                                  .data() as Map<String, dynamic>);
                              return Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 2, color: AppColors.white),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BuildListTitle(
                                            title:
                                                user.company!.capitalizeFirst!,
                                            width: 15),
                                        BuildListTitle(
                                            title: user.email!, width: 15),
                                        BuildListTitle(
                                            title: user.phone!, width: 15),
                                        BuildListTitle(
                                            title: user.address!, width: 15),
                                        BuildListTitle(
                                            title: user.name!, width: 15),
                                        BuildListTitle(
                                            title: '######' +
                                                user.password![
                                                    user.password!.length - 1],
                                            width: 15),
                                      ],
                                    ),
                                  )),
                                  BuildSizedBox(
                                    width: 2,
                                  ),
                                  BuildWhiteButton(
                                      onTap: () => {}, label: 'view / edit')
                                ],
                              );
                              return ExpansionTile(
                                backgroundColor: AppColors.white,
                                collapsedBackgroundColor: AppColors.white,
                                tilePadding: EdgeInsets.all(10),
                                childrenPadding: EdgeInsets.all(10),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BuildText(makeDate(user.date!),
                                        size: 0.8, fontWeight: FontWeight.bold),
                                    // BuildText('#' + user.id!,
                                    //     size: 1.5, fontWeight: FontWeight.bold),
                                    BuildSizedBox(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width:
                                              SizeConfig.widthMultiplier * 30,
                                          child: Column(
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
                                        ),
                                        Container(
                                          width:
                                              SizeConfig.widthMultiplier * 30,
                                          child: Column(
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width:
                                              SizeConfig.widthMultiplier * 30,
                                          child: Column(
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
                                      Spacer(),
                                      BuildSecondaryButton(
                                        onTap: () => controller.showUserDialog(
                                            true, user),
                                        label: 'View  / Edit',
                                        fontSize: 1,
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    } else if (snap.hasError) {
                      return BuildRetry(onRetry: () {});
                    } else {
                      return BuildCircularLoading();
                    }
                  })),
        )
      ],
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: controller.watch(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    if (snap.data!.docs.isEmpty) {
                      return Center(
                        child: BuildText(
                          'No User added',
                          color: AppColors.brown,
                          fontWeight: FontWeight.bold,
                        ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BuildText(makeDate(user.date!),
                                    size: 1.5, fontWeight: FontWeight.bold),
                                // BuildText('#' + user.id!,
                                //     size: 1.5, fontWeight: FontWeight.bold),
                                BuildSizedBox(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: SizeConfig.widthMultiplier * 25,
                                      child: Column(
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
                                    ),
                                    Container(
                                      width: SizeConfig.widthMultiplier * 25,
                                      child: Column(
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
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: SizeConfig.widthMultiplier * 25,
                                      child: Column(
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
                }),
          ),
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

class BuildListTitle extends StatelessWidget {
  const BuildListTitle(
      {required this.title,
      required this.width,
      this.isHeading = false,
      Key? key})
      : super(key: key);
  final String title;
  final double width;
  final bool isHeading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.widthMultiplier * width,
      child: BuildText(
        title.toUpperCase(),
        color: AppColors.white,
        size: isHeading ? 1.5 : 1.2,
        fontWeight: isHeading ? FontWeight.bold : FontWeight.normal,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
