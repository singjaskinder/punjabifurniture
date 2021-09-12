import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/apis/user.dart';
import 'package:punjabifurniture/common/buttons.dart';
import 'package:punjabifurniture/common/sized_box.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/models/user_m.dart';
import 'package:punjabifurniture/utils/local.dart';
import 'package:punjabifurniture/utils/overlays/dialog.dart';
import 'package:punjabifurniture/utils/overlays/progress_dialog.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/res/app_styles.dart';
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:responsive_builder/responsive_builder.dart';

enum ViewType {
  manageAction,
  addUser,
  manageUser,
}

class UsersController extends GetxController {
  final viewType = (ViewType.manageUser).obs;
  final userApis = UserRepo();
  final formKey = GlobalKey<FormState>();
  final companyCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final status = 'active'.obs;
  final showPassword = true.obs;

  @override
  void onReady() {
    super.onReady();
  }

  String viewTitle() {
    if (viewType.value == ViewType.addUser) {
      return 'create user';
    } else if (viewType.value == ViewType.manageUser) {
      return 'manage user';
    } else {
      return 'user profile';
    }
  }

  void togglePassword() => showPassword.value = !showPassword.value;

  void showUserDialog(bool isUpdate, UserM? user) {
    if (isUpdate) {
      companyCtrl.text = user!.company ?? '';
      emailCtrl.text = user.email ?? '';
      phoneCtrl.text = user.phone ?? '';
      addressCtrl.text = user.address ?? '';
      nameCtrl.text = user.name ?? '';
      passwordCtrl.text = '-';
      status.value = user.status ?? 'active';
    }
    Get.dialog(Scaffold(
        backgroundColor: AppColors.black.withOpacity(0.5),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
                  padding: EdgeInsets.all(15),
                  color: AppColors.white,
                  width: getValueForScreenType<double>(
                    context: Get.context!,
                    mobile: SizeConfig.widthMultiplier * 90,
                    desktop: SizeConfig.widthMultiplier * 60,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          BuildText(
                            isUpdate ? 'Update user details' : 'Add user +',
                            size: getValueForScreenType<double>(
                              context: Get.context!,
                              mobile: 2.8,
                              desktop: 2,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Get.back();
                                clearData();
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),
                      Divider(
                        color: AppColors.lightBrown,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: companyCtrl,
                              style: AppStyles.primaryTextStyle
                                  .copyWith(fontSize: 18),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  labelText: 'Company name',
                                  filled: true,
                                  fillColor: AppColors.brown.withOpacity(0.1),
                                  isDense: true),
                              validator: (val) => val!.isNotEmpty
                                  ? null
                                  : 'Please enter company name',
                            ),
                            BuildSizedBox(),
                            TextFormField(
                              controller: emailCtrl,
                              style: AppStyles.primaryTextStyle
                                  .copyWith(fontSize: 18),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  filled: true,
                                  fillColor: AppColors.brown.withOpacity(0.1),
                                  isDense: true),
                              validator: (val) => val!.isEmail
                                  ? null
                                  : 'Please enter valid email',
                            ),
                            BuildSizedBox(),
                            TextFormField(
                              controller: phoneCtrl,
                              style: AppStyles.primaryTextStyle
                                  .copyWith(fontSize: 18),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  labelText: 'Phone number',
                                  filled: true,
                                  fillColor: AppColors.brown.withOpacity(0.1),
                                  isDense: true),
                              validator: (val) => val!.isNum && val.length == 10
                                  ? null
                                  : 'Please enter valid phone number',
                            ),
                            BuildSizedBox(),
                            TextFormField(
                              controller: addressCtrl,
                              maxLines: 2,
                              style: AppStyles.primaryTextStyle
                                  .copyWith(fontSize: 18),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  labelText: 'Address',
                                  filled: true,
                                  fillColor: AppColors.brown.withOpacity(0.1),
                                  isDense: true),
                              validator: (val) => val!.isNotEmpty
                                  ? null
                                  : 'Please enter valid address',
                            ),
                            BuildSizedBox(),
                            TextFormField(
                              controller: nameCtrl,
                              style: AppStyles.primaryTextStyle
                                  .copyWith(fontSize: 18),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                  labelText: 'User name',
                                  filled: true,
                                  fillColor: AppColors.brown.withOpacity(0.1),
                                  isDense: true),
                              validator: (val) => val!.isNotEmpty
                                  ? null
                                  : 'Please enter valid user name',
                            ),
                            BuildSizedBox(),
                            Visibility(
                              visible: !isUpdate,
                              child: Obx(() => TextFormField(
                                    enabled: !isUpdate,
                                    controller: passwordCtrl,
                                    obscureText: showPassword.value,
                                    style: AppStyles.primaryTextStyle
                                        .copyWith(fontSize: 18),
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        filled: true,
                                        fillColor:
                                            AppColors.brown.withOpacity(0.1),
                                        isDense: true,
                                        suffixIcon: GestureDetector(
                                          onTap: () => togglePassword(),
                                          child: Icon(showPassword.value
                                              ? Icons.lock
                                              : Icons.lock_open_outlined),
                                        )),
                                    validator: (val) => val!.length >= 8
                                        ? null
                                        : 'Please enter valid password',
                                  )),
                            ),
                          ],
                        ),
                      ),
                      BuildSizedBox(),
                      Row(
                        children: [
                          BuildText('Status:',
                              size: getValueForScreenType<double>(
                                context: Get.context!,
                                mobile: 2.2,
                                desktop: 1,
                              ),
                              fontWeight: FontWeight.bold),
                          BuildSizedBox(
                            width: 2,
                          ),
                          GestureDetector(
                            onTap: () => status.value = 'active',
                            child: Obx(() => Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: status.value == 'active'
                                        ? AppColors.lightBrown
                                        : AppColors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: BuildText('ACTIVE',
                                      size: getValueForScreenType<double>(
                                        context: Get.context!,
                                        mobile: 2.2,
                                        desktop: 1,
                                      )),
                                )),
                          ),
                          GestureDetector(
                            onTap: () => status.value = 'inactive',
                            child: Obx(() => Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: status.value == 'inactive'
                                        ? AppColors.lightBrown
                                        : AppColors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: BuildText(
                                    'INACTIVE',
                                    size: getValueForScreenType<double>(
                                      context: Get.context!,
                                      mobile: 2.2,
                                      desktop: 1,
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                      BuildSizedBox(
                        height: 3,
                      ),
                      BuildPrimaryButton(
                        onTap: () => auUser(isUpdate, user),
                        label: isUpdate ? 'Update Details' : 'Add +',
                        fontSize: getValueForScreenType<double>(
                          context: Get.context!,
                          mobile: 2.5,
                          desktop: 1.8,
                        ),
                      ),
                      BuildSizedBox(),
                    ],
                  ))),
        )));
  }

  Future<void> auUser(bool isUpdate, UserM? userM) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        isLoading(true);
        final user = UserM(
            id: isUpdate ? userM!.id : '',
            date: setDate(),
            company: companyCtrl.text,
            email: emailCtrl.text,
            phone: phoneCtrl.text,
            address: addressCtrl.text,
            name: nameCtrl.text,
            password: passwordCtrl.text,
            status: status.value,
            type: 'user');
        if (isUpdate) {
          await userApis.update(user);
        } else {
          final auth = FirebaseAuth.instance;
          final userData = await auth.createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);
          user.id = userData.user!.uid;
          await userApis.create(user);
          await auth.signOut();
        }
        Get.back();
        clearData();
        isLoading(false);
        BuildDialog(
            title: 'Success',
            description: isUpdate ? 'User details updated' : 'New user added');
      } catch (e) {
        print(e);
        isLoading(false);
        BuildDialog();
      }
    }
  }

  Future<void> delete(UserM user) async {
    try {
      isLoading(true);
      userApis.delete(user);
      BuildDialog(title: 'Success', description: 'User details is removed');
      isLoading(false);
    } catch (e) {
      print(e);
      isLoading(false);
    }
  }

  Stream<QuerySnapshot> watch() async* {
    yield* userApis.watch('');
  }

  void clearData() {
    companyCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
    addressCtrl.clear();
    nameCtrl.clear();
    passwordCtrl.clear();
    status.value = 'active';
  }
}
