import 'package:athkarix/core/data/model/assma_hussna_list_model.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class AssmaHussnaController extends GetxController {
  void goToHome(); // مؤقتا
  void increaseFontSize();
  void decreaseFontSize();
  void resetCounter();
  void onPageChanged(int index);
  String getShareText(int index);
  void increamentPageController();
  void goToPage(int pageIndex); // for slider()
}

class AssmaHussnaControllerImp extends AssmaHussnaController {
  final PageController pageControllerAssma = PageController();
  // Proberties
  double fontSize = 21.0;
  int currentPageIndex = 0;
  int currentPageCounter = 0;
  List maxPageCounters = [];

  @override
  goToHome() {
    Get.toNamed(AppRoute.home);
  }

  @override
  increaseFontSize() {
    fontSize += 2.0;
    update();
  }

  @override
  decreaseFontSize() {
    fontSize -= 2.0;
    update();
  }

  @override
  void resetCounter() {
    currentPageCounter = 0;

    update();
  }

  // method to handle page change
  @override
  void onPageChanged(int index) {
    currentPageIndex = index; // try to fix using casting
    // reset counter
    resetCounter();
  }

  @override
  String getShareText(int index) {
    return assmaHussnaList[index].duaText ?? '';
  }

  @override
  void increamentPageController() {
    currentPageCounter++;

    if (currentPageCounter >= maxPageCounters[currentPageIndex]) {
      currentPageIndex++;

      if (currentPageIndex < maxPageCounters.length) {
        currentPageCounter = 0;

        pageControllerAssma.nextPage(
            duration: const Duration(microseconds: 500),
            curve: Curves.easeInOut);
      } else {
        Get.snackbar(
          'الحمدلله',
          '! أنهيت  قراءة أسماء الله الحسنى',
          colorText: AppColor.black,
          backgroundColor: AppColor.transparent,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    update();
  }

  @override
  void goToPage(int pageIndex) {
    pageControllerAssma.animateToPage(
      pageIndex,
      duration: const Duration(microseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
