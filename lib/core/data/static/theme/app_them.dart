import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  static final FontControllerImp fontController =
      Get.put(FontControllerImp()); // Use Get.put() to ensure initialization

  // Make the theme generation dynamic based on the controller's state
  static ThemeData get goldenTheme {
    // Access reactive values here
    String currentFontFamily = fontController.selectFont.value;
    double currentFontSize = fontController.fontSize.value;

    return ThemeData(
      fontFamily: currentFontFamily, // Use reactive font family
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          // Keep const if not using reactive values
          fontSize: 96.0,
          fontWeight: FontWeight.w500,
          color: AppColor.black,
        ),
        displayMedium: TextStyle(
          // Remove const
          fontWeight: FontWeight.w500,
          fontSize: 60.0,
          fontFamily: currentFontFamily, // Ensure consistency if needed
        ),
        titleLarge: TextStyle(
          // Make non-const if using reactive values
          fontSize: 21.0, // Or potentially currentFontSize * factor?
          fontWeight: FontWeight.w500,
          fontFamily: currentFontFamily,
          color: AppColor.primaryColorBlack, // Keep color
        ),
        titleMedium: TextStyle(
          // Make non-const
          fontSize: 21.0, // Or potentially currentFontSize * factor?
          fontWeight: FontWeight.bold,
          fontFamily: currentFontFamily,
          color: AppColor.primaryColorBlack2, // Keep color
        ),
        bodyLarge: TextStyle(
          fontSize: currentFontSize * 1.2, // Increase font size
          fontFamily: currentFontFamily,
          color: AppColor.black, // Keep color
          height: 1.6, // Consider adding line height for readability
        ),
        bodyMedium: TextStyle(
          fontSize: currentFontSize * 1.2, // Increase font size
          fontFamily: currentFontFamily,
          height: 1.6, // Consider adding line height
          // Potentially add a default color if needed
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: currentFontSize * 1.2, // Increase font size
          fontFamily: currentFontFamily,
          // Potentially add a default color if needed
        ),
        // Add other styles if needed, using currentFontSize and currentFontFamily
      ),
      // Apply other theme properties if necessary
    );
  } // End of getter

  // Update custom styles to use reactive values
  static TextStyle customTextStyleText() {
    // Access controller directly or pass it if needed
    final controller = Get.find<FontControllerImp>();
    return TextStyle(
      color: AppColor.primaryColorBlack,
      fontWeight: FontWeight.bold,
      fontFamily: controller.selectFont.value,
      fontSize:
          controller.fontSize.value, // Add font size if desired for this style
    );
  }

  static TextStyle customTextStyleFooter() {
    final controller = Get.find<FontControllerImp>();
    return TextStyle(
      color: AppColor.footer,
      fontWeight: FontWeight.bold,
      fontFamily: controller.selectFont.value,
      fontSize:
          controller.fontSize.value * 0.8, // Example: Footer text is smaller
    );
  }

  static TextStyle customTextStyleHadith() {
    final controller = Get.find<FontControllerImp>();
    return TextStyle(
      color: AppColor.ayahHadith,
      fontWeight: FontWeight.bold,
      fontFamily: controller.selectFont.value,
      fontSize: controller.fontSize.value, // Use base size or adjust
      height: 1.7, // Example: Slightly more line spacing for Hadith
    );
  }
}
