import 'package:flutter/material.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';

class BuildCircularLoading extends StatelessWidget {
  const BuildCircularLoading({
    this.loaderColor = AppColors.lighterBrown,
  });

  final Color loaderColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 4.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          loaderColor,
        ),
      ),
    );
  }
}
