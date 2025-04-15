import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:athkarix/core/data/model/model_list/dua_men_quran_list.dart';
import 'package:flutter/material.dart';

class DuaMenQuranControllerImp extends BaseAthkarController {
  final PageController pageControllerQuran = PageController();
  // new from clin ai
  @override
  PageController get pageController => pageControllerQuran;

  @override
  List<dynamic> get dataList => duaMenQuranList;

  @override
  List<int> get maxPageCounters => List.filled(duaMenQuranList.length, 1);

  @override
  String get completionMessage => 'أنهيت قراءة أدعية من القراءن !';

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
  //   return duaMenQuranList[index].duaText ?? '';
  // }
}
