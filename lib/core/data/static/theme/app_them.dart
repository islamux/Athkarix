import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class AppTheme {
//   // move it to seperated file
//   static final FontControllerImp fontController = Get.put(FontControllerImp());

//   static final List<String> fontList = ['Amiri', 'Cairo', 'Tajawal'];
//   // To allow user choose from list of fonts and save it to local storage

//   // First theme (light)
//   static ThemeData goldenTheme = ThemeData(
//     //Default Font Family ,
//     //fontFamily: "Tajawal",

//     //fontFamily: box.read('font') ?? 'Cairo', // Cairo Default
//     textTheme: TextTheme(
//       //
//       // Display Large (Headline 1)
//       displayLarge: TextStyle(
//         fontFamily: fontController.selectFont.value,
//         fontSize: 96.0,
//         fontWeight: FontWeight.w500,
//         color: AppColor.black,
//       ),

//       //Display Medium (HeadLine 2)
//       displayMedium: TextStyle(
//         fontFamily: fontController.selectFont.value,
//         fontWeight: FontWeight.w500,
//         fontSize: 60.0,
//       ),

//       //Title Large
//       titleLarge: TextStyle(
//         fontFamily: fontController.selectFont.value,
//         fontSize: 21.0,
//         fontWeight: FontWeight.w500,
//         color: AppColor.primaryColorBlack,
//       ),

//       // Title Medium bold Floating Buttons Theme
//       titleMedium: TextStyle(
//           fontFamily: fontController.selectFont.value,
//           fontSize: 17.0,
//           fontWeight: FontWeight.bold,
//           color: AppColor.primaryColorBlack2),

//       // Add Font Family for each text style
//       // Body Large (bodyText1) (text style)
//       bodyLarge: TextStyle(
//         fontFamily: fontController.selectFont.value,
//         fontSize: fontController.fontSize, // Amiri text
//         color: AppColor.black,
//       ),

//       // Font Family (bodyText2)
//       bodyMedium: TextStyle(
//         fontFamily: fontController.selectFont.value,
//         fontSize: fontController.fontSize,

//         // button
//       ),

//       //button
//       labelLarge: TextStyle(
//         fontFamily: fontController.selectFont.value,
//         fontWeight: FontWeight.w500,
//         fontSize: fontController.fontSize,
//       ),
//     ),
//   );

//   // Titles on AppBar *** testing not woking until now
//   static ThemeData appBarTheme = ThemeData(
//     fontFamily: 'Cairo',
//     textTheme: const TextTheme(
//       titleMedium: TextStyle(
//         fontSize: 16.0,
//         fontWeight: FontWeight.bold,
//         color: AppColor.bookYellowPage,
//         backgroundColor: AppColor.grey2,
//       ),
//     ),
//   );
// }

// Second Theme (Golden backgroudn + black color)

// English Theme

class AppTheme {
  //static final FontControllerImp fontController = Get.put(FontControllerImp());
  static final FontControllerImp fontController = Get.put(FontControllerImp());

  // static final List<String> fontList = ['Amiri', 'Cairo', 'Tajawal'];

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
}
