import 'package:flutter/material.dart';
import 'package:punjabifurniture/utils/res/app_colors.dart';

import 'buttons.dart';
import 'sized_box.dart';
import 'text.dart';

class BuildRetry extends StatelessWidget {
  BuildRetry({required this.onRetry, this.label = 'Something went wrong...'});
  final String label;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildText('Something went wrong...'),
            BuildSizedBox(),
            Container(
              child: BuildSecondaryButton(
                onTap: onRetry,
                label: 'Retry',
                elevation: 0,
                verticalPadding: 8,
                horizontalPadding: 10,
                borderRadius: 4,
              ),
            )
          ],
        ),
      ),
    );
  }
}
