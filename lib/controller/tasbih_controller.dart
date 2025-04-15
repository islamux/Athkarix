import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:athkarix/core/data/model/model_list/tasbih_list_model.dart';
import 'package:flutter/material.dart';

class TasbihControllerImp extends BaseAthkarController {
  final PageController pageControllerT = PageController();
  // new from clin ai
  @override
  PageController get pageController => pageControllerT;

  @override
  List<dynamic> get dataList => tasbihList;

  @override
  List<int> get maxPageCounters => List.filled(tasbihList.length, 1);

  @override
  String get completionMessage => 'أنهيت قراءة رسائل التسبيح ';

  // // Proberties
  // int currentPageIndex = 0;
  // int currentPageCounter = 0;
  // double fontSize = 21.0;
  // int counter = 0;

  // @override
  // onPageChanged(int index) {
  //   currentPageIndex = index;
  //   update();
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
  // increamentCounter() {
  //   counter++;
  // }

  // @override
  // resetCounter() {
  //   counter = 0;
  // }

  // @override
  // String getShareText(int index) {
  //   // import tasbihList
  //   return tasbihList[index].duaText ?? '';
  // }
}
