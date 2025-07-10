import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // Attributes
  final String customText;
  final void Function()? onPressed;
  final Icon icon;

  // Construcotr
  const CustomButton({
    super.key,
    required this.customText,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return // Button 1
        MaterialButton(
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      color: AppColor.primaryColorGolden,
      textColor: AppColor.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon customised as you like in your code
          icon,
          const SizedBox(width: 16),
          Text(
            customText,
            style: AppTheme.goldenTheme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
