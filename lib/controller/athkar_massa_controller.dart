import 'package:athkarix/core/data/model/athkar_massa_list_model.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class AthkarMassaController extends GetxController {
  void goToHome();
  void increaseFontSize();
  void decreaseFontSize();
  void increamentPageController();
  void resetCounter();
  void onPageChanged(int index);
  String getShareText(int index);
}

class AthkarMassaControllerImp extends AthkarMassaController {
  // instance from PageController to go to next page in pageview builder.
  final PageController pageControllerM = PageController();

  // Proberties
  double fontSize = 21.0;

  // PageController for go to next page in pageview builder
  int currentPageIndex = 0;
  int currentPageCounter = 0;
  List<int> maxPageCounters = [
    1, // الحمدلله وحده
    1, // الكرسي
    3, // المعوذات
    1, // امسينا وامسى الملك
    1, // بك امسينا
    1, // سيد الاستغفار
    4, // امسيت اشهدك
    1, // ما امسى
    3, // عافني
    7, // حسبي الله
    1, // العفو والعافيه
    1, // عالم الغيب
    3, // بسم الله
    3, //رضيت
    1, // يا حي ياقيوم
    1, // امسينا
    1, // امسينا
    100, // سبحان الله وبحمده
    10, // لا اله الا الله
    100, // استغفر الله
    3, // اعوذ بكلمات الله
    10 // اللهم صلى
  ];

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
  String getShareText(int index) {
    return athkarMassaList[index].duaText ?? '';
  }

  @override
  void increamentPageController() {
    currentPageCounter++;

    if (currentPageCounter >= maxPageCounters[currentPageIndex]) {
      currentPageIndex++;

      if (currentPageIndex < maxPageCounters.length) {
        // Reset to 0 then
        currentPageCounter = 1;
        // // vibrate before go to next t
        HapticFeedback.vibrate();

        // move to next page
        pageControllerM.nextPage(
            duration: const Duration(microseconds: 500),
            curve: Curves.easeInOut);
      } else {
        Get.snackbar('الحمدلله', '! أنهيت أذكار المساء',
            colorText: AppColor.black,
            backgroundColor: Colors.transparent,
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM);
      }
    }
    update();
  }

  @override
  void resetCounter() {
    currentPageCounter = 1;
    update();
  }

  // method to handle page change (pageview builder)
  @override
  void onPageChanged(int index) {
    currentPageIndex = index;
    // reset counter
    resetCounter();
  }
}
