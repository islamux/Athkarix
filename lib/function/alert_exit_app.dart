import 'dart:io';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/utils/responsive_helper.dart';
import 'package:athkarix/view/widget/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> alertExitApp() async {
  return Get.defaultDialog(
    title: "! تنبيه",
    middleText: "هل أنهيت أذكارك؟",
    middleTextStyle:
        TextStyle(fontSize: ResponsiveHelper.scaledFontSize(Get.context!, 16)),
    backgroundColor: const Color.fromRGBO(255, 224, 130, 1),
    confirmTextColor: AppColor.black,
    actions: [
      CustomButton(
          customText: "نعم",
          onPressed: () => exit(0),
          icon: const Icon(Icons.exit_to_app)),
      CustomButton(
          customText: "لا",
          onPressed: () => Get.back(),
          icon: const Icon(Icons.cancel)),
    ],
  );
}
