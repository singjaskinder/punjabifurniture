import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:punjabifurniture/common/sized_box.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/size_config.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'logout_controller.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LogoutController());
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => LogoutMobile(),
      desktop: (BuildContext context) => LogoutDesktop(),
    );
  }
}

class LogoutDesktop extends StatelessWidget {
  const LogoutDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LogoutController controller = Get.find();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BuildSizedBox(height: 4),
        Obx(() => BuildSwitch(
              onSelected: (i) => controller.decide(i),
              title: 'Log out',
              labels: ['YES', 'CANCEL'],
              preSelection: controller.switchIndex.value,
            )),
      ],
    );
  }
}

class LogoutMobile extends StatelessWidget {
  const LogoutMobile({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final LogoutController controller = Get.find();
    return Column(
      children: [],
    );
  }
}

class BuildSwitch extends StatefulWidget {
  const BuildSwitch(
      {required this.onSelected,
      required this.preSelection,
      required this.labels,
      required this.title,
      Key? key})
      : super(key: key);

  final int preSelection;
  final Function(int) onSelected;
  final List<String> labels;
  final String title;

  @override
  _BuildSwitchState createState() => _BuildSwitchState();
}

class _BuildSwitchState extends State<BuildSwitch> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedIndex = widget.preSelection;
    return Column(
      children: [
        BuildText(
          widget.title,
          size: 2.5,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        BuildSizedBox(),
        Container(
          width: SizeConfig.widthMultiplier * 30,
          decoration: BoxDecoration(
              color: AppColors.darkBrown,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              for (int i = 0; i < widget.labels.length; i++)
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = i;
                    });
                    widget.onSelected(i);
                  },
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: selectedIndex == i
                            ? AppColors.white
                            : AppColors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: BuildText(
                      widget.labels[i],
                      size: 1.5,
                      textAlign: TextAlign.center,
                      color: selectedIndex == i
                          ? AppColors.black
                          : AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
            ],
          ),
        )
      ],
    );
  }
}
