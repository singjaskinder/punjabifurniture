import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:punjabifurniture/utils/routes/app_routes.dart';

class LandingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkUser();
  }

  void checkUser() {
    // final saver = Preferences.saver;
    final user = FirebaseAuth.instance.currentUser;
    // if (saver.getString('authKey')!.isNotEmpty) {
    //   Get.toNamed(Routes.landing);
    // }
    Future.delayed(Duration(microseconds: 1), () {
      Get.toNamed(user == null ? Routes.login : Routes.home);
    });
    
  }
}
