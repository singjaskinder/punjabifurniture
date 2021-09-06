import 'package:flutter/material.dart';
import 'package:punjabifurniture/common/text.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';

class InvalidView extends StatelessWidget {
  const InvalidView({this.message, Key? key}) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      body: Center(
        child: BuildText(''),
      ),
    );
  }
}
