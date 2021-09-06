import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:punjabifurniture/utils/functions/preferences.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/routes/app_routes.dart';
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Preferences.init();
  runApp(Pramukh());
}

class Pramukh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return LayoutBuilder(builder: (_, constraints) {
          return OrientationBuilder(builder: (_, orientation) {
            SizeConfig().init(constraints, orientation);
            return GetMaterialApp(
              title: 'Punjabi Furniture',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: const ColorScheme.dark().copyWith(
                  primary: AppColors.darkerBrown,
                  brightness: Brightness.light,
                ),
                appBarTheme:
                    AppBarTheme(backgroundColor: AppColors.brown, elevation: 0),
                scaffoldBackgroundColor: AppColors.white,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                primaryColor: AppColors.darkBrown,
                accentColor: AppColors.darkBrown,
              ),
              defaultTransition: Transition.fadeIn,
              initialRoute: Routes.landing,
              getPages: Routes.pages,
            );
          });
        });
      },
    );
  }
}
