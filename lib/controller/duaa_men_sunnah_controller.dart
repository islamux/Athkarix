import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:athkarix/core/data/model/model_list/dua_men_sunnah_list.dart';
import 'package:flutter/material.dart';

class DuaMenSunnahControllerImp extends BaseAthkarController {
  final PageController pageControllerSunnah = PageController();
  // new from clin ai
  @override
  PageController get pageController => pageControllerSunnah;

  @override
  List<dynamic> get dataList => duaMenSunnahList;

  @override
  List<int> get maxPageCounters => List.filled(duaMenSunnahList.length, 1);

  @override
  String get completionMessage => 'أنهيت قراءة أدعية من السنة !';

  // // Proberties
  // int currentPageIndex = 0;
  // int currentPageCounter = 0;
  // double fontSize = 21.0;
  // int counter = 0;

  // @override
  // goToHome() {
  //   Get.toNamed(AppRoute.home);
  // }

  // @override
  // onPageChanged(int index) {
  //   currentPageIndex = index;
  //   update();
  // }

  // @override
  // decreaseFontSize() {
  //   fontSize -= 2;
  //   update();
  // }

  // @override
  // increaseFontSize() {
  //   fontSize += 2;
  //   update();
  // }

  // @override
  // String getShareText(int index) {
  //   return duaMenSunnahList[index].duaText ?? '';
  // }
}
