import 'dart:io';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/view/widget/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// using my custom buttom
Future<bool> alertExitApp() {
  Get.defaultDialog(
    title: "! تنبيه  ",
    middleText: "هل أنهيت أذكارك ؟",
    middleTextStyle: const TextStyle(fontSize: 16.0),
    backgroundColor: const Color.fromRGBO(255, 224, 130, 1),
    confirmTextColor: AppColor.black,
    actions: [
      CustomButton(
          customText: "نعم ",
          onPressed: () => exit(0),
          icon: const Icon(Icons.exit_to_app)),
      CustomButton(
          customText: "لا",
          onPressed: () => Get.back(),
          icon: const Icon(Icons.cancel)),
    ],
  );
  return Future.value(true);
}
