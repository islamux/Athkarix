import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_after_salat_list.dart';
import 'package:flutter/material.dart';

class AthkarAfterSalatControllerImp extends BaseAthkarController {
  // instance from PageController to go to next page in pageview builder.
  PageController pageControllerS = PageController();

  @override
  String get completionMessage => 'أنهيت قراءة أذكار مابعد الصلاة';

  @override
  List get dataList => athkarAfterSalatList;

  @override
  List<int> get maxPageCounters => List.filled(athkarAfterSalatList.length, 1);

  @override
  PageController get pageController => pageControllerS;

  // // Proberties
  // double fontSize = 21.0;
  // int currentPageIndex = 0;
  // int currentPageCounter = 0;

  // List<int> maxPageCounters = [
  //   3, // استغفر الله
  //   1, // االلهم انت السلام
  //   3, // لا اله الا الله
  //   1, // اللهم الا مانع
  //   1, // مخلصين
  //   100, // سبحان الله الحمد الله  الله اكبر لا اله الا  الله
  //   1, // االكرسي
  //   3, // المعوذات
  //   10, //لا اله الا الله .. الفحر المغرب
  //   1, //اعني
  //   1 //أعوذ بك
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
  //       // // vibrate before go to next t
  //       HapticFeedback.vibrate();

  //       pageControllerS.nextPage(
  //           duration: const Duration(microseconds: 500),
  //           curve: Curves.easeInOut);
  //     } else {
  //       Get.snackbar(
  //         'الحمدلله',
  //         '! أنهيت أذكار بعد الصلاة',
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
  //   return athkarAfterSalatList[index].duaText ?? '';
  // }
}
