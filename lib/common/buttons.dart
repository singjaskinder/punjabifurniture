import 'package:flutter/material.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'text.dart';
import 'sized_box.dart';

class BuildPrimaryButton extends StatelessWidget {
  const BuildPrimaryButton(
      {this.elevation = 6.0,
      this.borderRadius = 12.0,
      this.fontSize = 2.17,
      required this.onTap,
      this.color = AppColors.darkBrown,
      required this.label,
      this.textColor = AppColors.white,
      this.verticalPadding = 14.0,
      this.horizontalPadding = 4.0,
      this.isEnabled = true,
      this.isOutlined = false});

  final double elevation;
  final double borderRadius;
  final double fontSize;
  final double verticalPadding;
  final double horizontalPadding;
  final VoidCallback onTap;
  final Color color;
  final String label;
  final Color textColor;
  final bool isEnabled;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Material(
          borderRadius: BorderRadius.circular(borderRadius),
          elevation: isEnabled
              ? isOutlined
                  ? 0
                  : elevation
              : 0,
          color: isEnabled
              ? isOutlined
                  ? AppColors.transparent
                  : color
              : AppColors.grey.withOpacity(0.5),
          child: InkWell(
            splashColor: AppColors.brown,
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: isEnabled ? onTap : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border:
                    isOutlined ? Border.all(color: color, width: 1.2) : null,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Center(
                child: BuildText(
                  label,
                  color: isOutlined ? color : textColor,
                  size: fontSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Almarai',
                ),
              ),
            ),
          ),
        ));
  }
}

class BuildSecondaryButton extends StatelessWidget {
  const BuildSecondaryButton({
    Key? key,
    required this.onTap,
    required this.label,
    this.color = AppColors.transparent,
    this.fontColor = AppColors.darkBrown,
    this.borderRadius = 6,
    this.elevation = 0,
    this.fontSize = 2.17,
    this.verticalPadding = 6.0,
    this.horizontalPadding = 4.0,
  }) : super(key: key);

  final VoidCallback onTap;
  final String label;
  final double fontSize;
  final Color fontColor;
  final double borderRadius;
  final double elevation;
  final Color color;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.darkBrown.withOpacity(0.5),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 8.0,
            ),
            child: BuildText(
              label,
              color: fontColor,
              size: fontSize,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class BuildIconTextButton extends StatelessWidget {
  const BuildIconTextButton({
    Key? key,
    required this.onTap,
    required this.iconData,
    this.iconSize,
    required this.label,
    this.labelSize = 16.5,
    this.color = AppColors.darkBrown,
    this.isFill = false,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData iconData;
  final double? iconSize;
  final String label;
  final double labelSize;
  final Color color;
  final bool isFill;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isFill ? color : AppColors.transparent,
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
      child: InkWell(
        highlightColor: AppColors.brown,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        onTap: onTap,
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 1.0, vertical: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              border: Border.all(color: color),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: isFill ? AppColors.white : color,
                  size: iconSize,
                ),
                BuildSizedBox(),
                BuildText(
                  label,
                  color: isFill ? AppColors.white : color,
                  size: labelSize,
                  // fontWeight: FontWeight.bold,
                  fontFamily: 'MavenProEB',
                ),
              ],
            )),
      ),
    );
  }
}

class BuildRoundedFloatingButton extends StatelessWidget {
  const BuildRoundedFloatingButton(
      {required this.label, required this.onTap, this.fontSize = 1.2, Key? key})
      : super(key: key);
  final String label;
  final VoidCallback onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        splashColor: AppColors.white.withOpacity(0.5),
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          decoration: BoxDecoration(
            color: AppColors.darkerBrown,
            borderRadius: BorderRadius.circular(40),
          ),
          child: BuildText(
            label,
            size: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.lighterBrown,
          ),
        ),
      ),
    );
  }
}
