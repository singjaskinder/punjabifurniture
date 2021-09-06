import 'package:get/get.dart';
import 'package:punjabifurniture/common/build_circular_loading.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';

void isLoading(bool status) {
  status
      ? Get.dialog(
          BuildCircularLoading(loaderColor: AppColors.lightBrown),
          barrierDismissible: false,
        )
      : Get.back();
}
