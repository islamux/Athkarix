import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomFloatingButton extends StatelessWidget {
  // instance off FloatingController
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
    return SizedBox(
      height: 80.0,
      width: 80.0,
      child: FloatingActionButton(
        onPressed: onPressed,
        heroTag: herotag,
        foregroundColor: AppColor.black,
        backgroundColor: AppColor.floatingColor2,
        elevation: 2,
        shape: const StadiumBorder(),
        //StadiumBorder:disable the button when the counter reaches the maxCounter value
        // or when maxCounter is not specified
        disabledElevation: 0,
        isExtended: true,

        child: text,
      ),
    );
  }
}
