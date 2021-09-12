import 'package:flutter/material.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';
import 'package:punjabifurniture/utils/size_config.dart';

class BuildText extends StatelessWidget {
  const BuildText(
    this.text, {
    this.size = 2.17,
    this.color = AppColors.black,
    this.fontWeight = FontWeight.w400,
    this.textAlign,
    this.letterSpacing,
    this.fontFamily,
    this.lineHeight,
    this.overflow,
    this.textDecoration,
    this.maxLines,
    Key? key,
  }) : super(key: key);

  final String text;
  final double size;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final String? fontFamily;
  final double? lineHeight;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
          fontSize: SizeConfig.textMultiplier * size,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          color: color,
          letterSpacing: letterSpacing,
          height: lineHeight,
          decoration: textDecoration),
    );
  }
}
