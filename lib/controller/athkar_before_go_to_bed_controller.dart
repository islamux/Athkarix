import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_before_go_to_bed_list.dart';
import 'package:flutter/material.dart';

class AthkarBeforeGoToBedControllerImp extends BaseAthkarController {
  // instance from PageController to go to next page in pageview builder.
  PageController pageControllerS = PageController();
  // new from clin ai
  @override
  PageController get pageController => pageControllerS;

  @override
  List<dynamic> get dataList => athkarBeforeGoToBedList;

  @override
  List<int> get maxPageCounters =>
      List.filled(athkarBeforeGoToBedList.length, 1);

  @override
  String get completionMessage => 'أنهيت قراءة أذكار النوم !';

  // // Proberties
  // double fontSize = 21.0;
  // int currentPageIndex = 0;
  // int currentPageCounter = 0;

  // List<int> maxPageCounters = [
  //   3, // المعوذات
  //   1, // ايه الكرسي
  //   1, // امن الرسول
  //   1, //  وضعت جنبي
  //   1, // باسمك
  //   100, // سبحان الله الحمد الله  الله اكبر
  //   1, // رب السموات
  //   1, // فكم من لا كافي له
  //   1, // السجدة
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
  //   return athkarBeforeGoToBedList[index].duaText ?? '';
  // }
}
