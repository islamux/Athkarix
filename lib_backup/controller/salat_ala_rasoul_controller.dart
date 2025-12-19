import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:athkarix/core/data/model/model_list/salat_ala_rasoul_list_model.dart';
import 'package:flutter/material.dart';

class SalatAlaRasoulAllahControllerImp extends BaseAthkarController {
  final PageController pageControllerR = PageController();
  // new from clin ai
  @override
  PageController get pageController => pageControllerR;

  @override
  List<dynamic> get dataList => salatAlaRasoulAllahList;

  @override
  List<int> get maxPageCounters =>
      List.filled(salatAlaRasoulAllahList.length, 1);

  @override
  String get completionMessage => 'أنهيت الصلاة على الرسول';

  // // Proberties
  // int currentPageIndex = 0;
  // int currentPageCounter = 0;
  // double fontSize = 21.0;

  // @override
  // onPageChanged(int index) {
  //   currentPageIndex = index;
  //   update();
  // }

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
  // String getShareText(int index) {
  //   return salatAlaRasoulAllahList[index].duaText ?? '';
  // }
}
