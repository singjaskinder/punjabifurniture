import 'package:get/get.dart';
import 'package:punjabifurniture/apis/auth.dart';
import 'package:punjabifurniture/utils/functions/preferences.dart';
import 'package:punjabifurniture/utils/overlays/dialog.dart';
import 'package:punjabifurniture/utils/routes/app_routes.dart';
import 'package:punjabifurniture/views/navigator/buildnavigator_controller.dart';

class LogoutController extends GetxController {
  final authApis = AuthRepo();
  final switchIndex = (-1).obs;
  BuildNavigatorController buildNavigatorController = Get.find();

  void decide(int i) {
    switchIndex.value = i;
    if (i == 0) {
      toLogout();
    } else {
      cancel();
    }
  }

  void toLogout() {
    final onPos = () async {
      await authApis.logout();
      Preferences.saver.clear();
      Get.offNamed(Routes.login);
      switchIndex.value = -1;
    };
    final onNeg = () async {
      Get.back();
      switchIndex.value = -1;
    };
    BuildDialog(
        title: 'Confirmation',
        description: 'Are you sure you want to logout?',
        negLabel: 'No',
        posLabel: 'Yes',
        onPos: onPos,
        onNeg: onNeg);
  }

  void cancel() {
    buildNavigatorController.selectedIndex.value = 0;
    switchIndex.value = -1;
  }
}
