import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/apis/auth.dart';
import 'package:punjabifurniture/utils/functions/preferences.dart';
import 'package:punjabifurniture/utils/overlays/dialog.dart';
import 'package:punjabifurniture/utils/routes/app_routes.dart';
import 'package:punjabifurniture/views/navigator/dashboard/dashboard.dart';
import 'package:punjabifurniture/views/navigator/history/history.dart';
import 'package:punjabifurniture/views/navigator/users/users.dart';

import 'logout/logout.dart';

class BuildNavigatorController extends GetxController {
  final authApis = AuthRepo();
  late bool isAdmin;
  final selectedIndex = 1.obs;
  final menus = [
    NavMenu(label: 'Dashboard', view: Dashboard()),
    NavMenu(label: 'Users', view: Users()),
    NavMenu(label: 'Order', view: Users()),
    NavMenu(label: 'Order Status', view: Users()),
    NavMenu(label: 'Users', view: Users()),
    NavMenu(label: 'History', view: History()),
    NavMenu(label: 'Logout', view: Logout()),
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

  
}

class NavMenu {
  NavMenu({this.label, this.view, this.iconData});
  String? label;
  Widget? view;
  IconData? iconData;
}
