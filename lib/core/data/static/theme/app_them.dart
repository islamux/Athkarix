import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  //static final FontControllerImp fontController = Get.put(FontControllerImp());
  static final FontControllerImp fontController = Get.put(FontControllerImp());

  static ThemeData goldenTheme = ThemeData(
    fontFamily: 'Amiri',
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 96.0,
        fontWeight: FontWeight.w500,
        color: AppColor.black,
      ),
      displayMedium: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 60.0,
      ),
      titleLarge: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: AppColor.primaryColorBlack,
      ),
      // Start Main colors in app
      titleMedium: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: AppColor.primaryColorBlack2,
      )
      // End fonts in app
      ,
      bodyLarge: TextStyle(
        fontSize: fontController.fontSize,
        color: AppColor.black,
      ),
      bodyMedium: TextStyle(
        fontSize: fontController.fontSize,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: fontController.fontSize,
      ),
    ),
  );

  static TextStyle customTextStyleText() {
    return const TextStyle(
      color: AppColor.primaryColorBlack,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle customTextStyleFooter() {
    return const TextStyle(
      color: AppColor.footer,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle customTextStyleHadith() {
    return const TextStyle(
      color: AppColor.ayahHadith,
      fontWeight: FontWeight.bold,
    );
  }
}
