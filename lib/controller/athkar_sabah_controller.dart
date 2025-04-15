import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_sabah_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AthkarSabahControllerImp extends BaseAthkarController {
  // instance from PageController to go to next page in pageview builder.
  PageController pageControllerS = PageController();

  // Provide the specific PageController for this page
  @override
  PageController get pageController => pageControllerS;

  // Provide the completion message for this page
  @override
  String get completionMessage => 'أنهيت أذكار الصباح !';

// Provide the specific data list for this page
// Make sure the model list is imported: import 'package:athkarix/core/data/model/model_list/athkar_sabah_list_model.dart';
  @override
  List<dynamic> get dataList => athkarSabahList;

  // Provide the specific max counters for this page (use the existing list)
  @override
  List<int> get maxPageCounters => [
        1,
        1,
        3,
        1,
        1,
        1,
        4,
        1,
        3,
        7,
        1,
        1,
        3,
        3,
        1,
        1,
        1,
        100,
        10,
        100,
        3,
        1,
        100,
        10
      ];

  // --- Optional Specific Overrides ---
  // If Athkar Sabah needs a different starting counter or specific haptic feedback,
  // you could override methods like resetCounter or increamentPageController here.
  // For example, if it needs haptic feedback:
  @override
  void increamentPageController() {
    currentPageCounter++;
    if (currentPageCounter >= maxPageCounters[currentPageIndex]) {
      currentPageIndex++;
      if (currentPageIndex < maxPageCounters.length) {
        currentPageCounter = 0; // Or 1 if needed
        HapticFeedback.vibrate(); // Specific haptic feedback
        pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      } else {
        Get.snackbar('الحمدلله', completionMessage);
      }
    }
    update();
  }
  // If no specific overrides are needed, you don't need to add anything else.

  // @override
  // List<int> maxPageCounters = [
  //   1, // الحمد
  //   1, // الكرسي
  //   3, // المعوذات
  //   1, //اصبحنا واصبح الملك
  //   1, // بك اصبحنا
  //   1, // سيد الاستغفار
  //   4, // اصبحت اشهدك
  //   1, //ما اصبح بي
  //   3, //عافني في بدني
  //   7, //حسبي الله
  //   1, //العفو والغافية
  //   1, // عالم الغيب
  //   3, //بسم الله الذي
  //   3, // رضيت بالله
  //   1, //ياحي ياقيوم
  //   1, //اصبحنا واصبح الملك
  //   1, // أصبحنا على فطرة
  //   100, // سبحان الله وبحمده
  //   10, // لا اله الا الله
  //   100, // لا اله الا الله
  //   3, // سبحان الله وبحمده
  //   1, // علما نافعا
  //   100, // استغفر الله
  //   10 // اللهم صلى
  // ];

  // @override
  // goToHome() {
  //   Get.toNamed(AppRoute.home);
  // }

  // @override
  // increaseFontSize() {
  //   fontSize += 2.0;
  //   update();
  // }

  // @override
  // decreaseFontSize() {
  //   fontSize -= 2.0;
  //   update();
  // }

  // @override
  // void increamentPageController() {
  //   currentPageCounter++;

  //   if (currentPageCounter >= maxPageCounters[currentPageIndex]) {
  //     currentPageIndex++;

  //     if (currentPageIndex < maxPageCounters.length) {
  //       currentPageCounter = 1;

  //       // // vibrate before go to next
  //       HapticFeedback.vibrate();

  //       pageControllerS.nextPage(
  //           duration: const Duration(microseconds: 500),
  //           curve: Curves.easeInOut);
  //     } else {
  //       Get.snackbar(
  //         'تنبية',
  //         '! أنهيت أذكار الصباح',
  //         colorText: AppColor.black,
  //         backgroundColor: AppColor.transparent,
  //         duration: const Duration(seconds: 5),
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //     }
  //   }
  //   update();
  // }

  // @override
  // void resetCounter() {
  //   currentPageCounter = 1;

  //   update();
  // }

  // // method to handle page change
  // @override
  // void onPageChanged(int index) {
  //   currentPageIndex = index;
  //   // reset counter
  //   resetCounter();
  // }

  // @override
  // String getShareText(int index) {
  //   return athkarSabahList[index].duaText ?? '';
  // }
}
