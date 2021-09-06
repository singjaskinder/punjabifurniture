import 'package:flutter/material.dart';
import 'package:punjabifurniture/common/sized_box.dart';

class BuildTitleTextField extends StatelessWidget {
  const BuildTitleTextField(
      {required this.titleText, required this.textField, Key? key})
      : super(key: key);
  final Widget titleText;
  final Widget textField;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [titleText, BuildSizedBox(height: 0.7), textField],
    );
  }
}
