import 'package:athkarix/core/data/model/athkar_sabah_list_model.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class AthkarSabahController extends GetxController {
  void goToHome(); // مؤقتا
  void increaseFontSize();
  void decreaseFontSize();
  void increamentPageController();
  void resetCounter();
  void onPageChanged(int index);
  String getShareText(int index);
}

class AthkarSabahControllerImp extends AthkarSabahController {
  // instance from PageController to go to next page in pageview builder.
  PageController pageControllerS = PageController();
  // Proberties
  double fontSize = 21.0;
  int currentPageIndex = 0;
  int currentPageCounter = 0;

  List<int> maxPageCounters = [
    1, // الحمد
    1, // الكرسي
    3, // المعوذات
    1, //اصبحنا واصبح الملك
    1, // بك اصبحنا
    1, // سيد الاستغفار
    4, // اصبحت اشهدك
    1, //ما اصبح بي
    3, //عافني في بدني
    7, //حسبي الله
    1, //العفو والغافية
    1, // عالم الغيب
    3, //بسم الله الذي
    3, // رضيت بالله
    1, //ياحي ياقيوم
    1, //اصبحنا واصبح الملك
    1, // أصبحنا على فطرة
    100, // سبحان الله وبحمده
    10, // لا اله الا الله
    100, // لا اله الا الله
    3, // سبحان الله وبحمده
    1, // علما نافعا
    100, // استغفر الله
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
  Future<void> increamentPageController() async {
    currentPageCounter++;
    print(currentPageIndex);
    if (currentPageCounter >= maxPageCounters[currentPageIndex]) {
      currentPageIndex++;
      print(currentPageCounter);
      if (currentPageIndex < maxPageCounters.length) {
        currentPageCounter = 1;
        print(currentPageCounter);

        // // vibrate before go to next
        HapticFeedback.vibrate();

        pageControllerS.nextPage(
            duration: const Duration(microseconds: 500),
            curve: Curves.easeInOut);
        print(currentPageCounter);
      } else {
        Get.snackbar(
          'تنبية',
          '! أنهيت أذكار الصباح',
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
  void resetCounter() {
    currentPageCounter = 1;

    update();
  }

  // method to handle page change
  @override
  void onPageChanged(int index) {
    currentPageIndex = index;
    // reset counter
    resetCounter();
  }

  @override
  String getShareText(int index) {
    return athkarSabahList[index].duaText ?? '';
  }
}
