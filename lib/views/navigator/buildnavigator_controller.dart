import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/apis/auth.dart';
import 'package:punjabifurniture/utils/functions/preferences.dart';
import 'package:punjabifurniture/utils/overlays/dialog.dart';
import 'package:punjabifurniture/utils/routes/app_routes.dart';
import 'package:punjabifurniture/views/navigator/dashboard/dashboard.dart';
import 'package:punjabifurniture/views/navigator/history/history.dart';
import 'package:punjabifurniture/views/navigator/users/users.dart';

class BuildNavigatorController extends GetxController {
  final authApis = AuthRepo();
  late bool isAdmin;
  final selectedIndex = 0.obs;
  final menus = [
    NavMenu(label: 'Dashboard', view: Dashboard()),
    NavMenu(label: 'Users', view: Users()),
    NavMenu(label: 'History', view: History()),
  ];
  late String type;

  @override
  void onInit() {
    super.onInit();
    isAdmin = (Preferences.saver.getString('type') ?? 'admin') == 'admin';
    if (!isAdmin) {
      menus.removeAt(1);
    }
  }

  void toLogout() {
    final onPos = () async {
      await authApis.logout();
      Get.offNamed(Routes.login);
    };
    BuildDialog(
        title: 'Confirmation',
        description: 'Are you sure you want to logout?',
        negLabel: 'No',
        posLabel: 'Yes',
        onPos: onPos);
  }
}

class NavMenu {
  NavMenu({this.label, this.view, this.iconData});
  String? label;
  Widget? view;
  IconData? iconData;
}
