import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:athkarix/core/data/model/model_list/estigfar_list_model.dart';
import 'package:flutter/material.dart';

class EstigfarControllerImp extends BaseAthkarController {
  final PageController pageControllerEs = PageController();
  // new from clin ai
  @override
  PageController get pageController => pageControllerEs;

  @override
  List<dynamic> get dataList => estigfarList;

  @override
  List<int> get maxPageCounters => List.filled(estigfarList.length, 1);

  @override
  String get completionMessage => 'أنهيت قراءة رسائل الإإستغفار ';

  // double fontSize = 21.0;
  // int currentPageIndex = 0;
  // int currentPageCounter = 0;

  // @override
  // void onPageChanged(int index) {
  //   currentPageIndex = index;
  //   update();
  // }

  // @override
  // void increaseFontSize() {
  //   fontSize += 2.0;
  //   update();
  // }

  // @override
  // void decreaseFontSize() {
  //   fontSize -= 2.0;
  //   update();
  // }

  // @override
  // void goToHome() {}

  // @override
  // String getShareText(int index) {
  //   return estigfarList[index].duaText ?? '';
  // }
}
