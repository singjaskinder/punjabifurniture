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
  final viewType = (ViewType.manageAction).obs;
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
  final isUpdate = false.obs;
  late String userId;
  late int userDate;
  final switchIndex = (0).obs;

  @override
  void onReady() {
    super.onReady();
  }

  String viewTitle() {
    if (viewType.value == ViewType.addUser) {
      return isUpdate.value ? 'edit user' : 'create user';
    } else if (viewType.value == ViewType.manageUser) {
      return 'manage user';
    } else {
      return 'user profile';
    }
  }

  void togglePassword() => showPassword.value = !showPassword.value;

  void updateUser(UserM user) {
    isUpdate.value = true;
    viewType.value = ViewType.addUser;
    userId = user.id!;
    userDate = user.date!;
    companyCtrl.text = user.company ?? '';
    emailCtrl.text = user.email ?? '';
    phoneCtrl.text = user.phone ?? '';
    addressCtrl.text = user.address ?? '';
    nameCtrl.text = user.name ?? '';
    passwordCtrl.text = user.password ?? '';
    status.value = user.status ?? 'active';
  }

  void decide() {
    if (isUpdate.value) {
      auUser(true, UserM(id: userId, date: userDate));
    } else {
      auUser(false, null);
    }
  }

  Future<void> auUser(bool isUpdate, UserM? userM) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        isLoading(true);
        final user = UserM(
            id: isUpdate ? userM!.id : '',
            date: isUpdate ? userM!.date : setDate(),
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
    isUpdate.value = false;
    companyCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
    addressCtrl.clear();
    nameCtrl.clear();
    passwordCtrl.clear();
    status.value = 'active';
    viewType.value = ViewType.manageAction;
  }
}
