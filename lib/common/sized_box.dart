import 'package:flutter/material.dart';
import 'package:punjabifurniture/utils/size_config.dart';

class BuildSizedBox extends StatelessWidget {
  const BuildSizedBox({this.width = 1.5, this.height = 1.5, this.child, key})
      : super(key: key);
  final double width;
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.widthMultiplier * width,
      height: SizeConfig.heightMultiplier * height,
      child: child,
    );
  }
}
