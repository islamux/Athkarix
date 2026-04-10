import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String customText;
  final void Function()? onPressed;
  final Icon icon;

  const CustomButton({
    super.key,
    required this.customText,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: ResponsiveHelper.scaledFontSize(context, 16),
      ),
      color: AppColor.primaryColorGolden,
      textColor: AppColor.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon.icon,
            size: ResponsiveHelper.scaledIconSize(context, 24),
          ),
          SizedBox(width: ResponsiveHelper.scaledFontSize(context, 16)),
          Text(
            customText,
            style: AppTheme.goldenTheme.textTheme.titleMedium?.copyWith(
              fontSize: ResponsiveHelper.scaledFontSize(context, 21),
            ),
          ),
        ],
      ),
    );
  }
}
