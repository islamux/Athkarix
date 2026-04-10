import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomFloatingButton extends StatelessWidget {
  final FloatingButtonControllerImp floatingController =
      Get.find<FloatingButtonControllerImp>();
  final Object herotag;
  final void Function()? onPressed;
  final Text text;

  CustomFloatingButton({
    super.key,
    required this.herotag,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveHelper.scaledFontSize(context, 80);
    return SizedBox(
      height: size,
      width: size,
      child: FloatingActionButton(
        onPressed: onPressed,
        heroTag: herotag,
        foregroundColor: AppColor.black,
        backgroundColor: AppColor.floatingColor2,
        elevation: 2,
        shape: const StadiumBorder(),
        disabledElevation: 0,
        isExtended: true,
        child: DefaultTextStyle(
          style: text.style?.copyWith(
                fontSize: ResponsiveHelper.scaledFontSize(
                    context, text.style?.fontSize ?? 21),
              ) ??
              TextStyle(
                fontSize: ResponsiveHelper.scaledFontSize(context, 21),
              ),
          child: text,
        ),
      ),
    );
  }
}
