import 'package:athkarix/core/data/model/model_list/dua_men_sunnah_list.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class DuaMenSunnahController extends GetxController {
  void goToHome();
  void increaseFontSize();
  void decreaseFontSize();
  void onPageChanged(int index);
  String getShareText(int index);
}

class DuaMenSunnahControllerImp extends DuaMenSunnahController {
  final PageController pageControllerSunnah = PageController();
  // Proberties
  int currentPageIndex = 0;
  int currentPageCounter = 0;
  double fontSize = 21.0;
  int counter = 0;

  @override
  goToHome() {
    Get.toNamed(AppRoute.home);
  }

  @override
  onPageChanged(int index) {
    currentPageIndex = index;
    update();
  }

  @override
  decreaseFontSize() {
    fontSize -= 2;
    update();
  }

  @override
  increaseFontSize() {
    fontSize += 2;
    update();
  }

  @override
  String getShareText(int index) {
    return duaMenSunnahList[index].duaText ?? '';
  }
}
