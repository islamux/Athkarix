import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:athkarix/core/data/model/model_list/hamd_list_model.dart';
import 'package:flutter/material.dart';

class HamdControllerImp extends BaseAthkarController {
  final PageController pageControllerHamd = PageController();
  // new from clin ai
  @override
  PageController get pageController => pageControllerHamd;

  @override
  List<dynamic> get dataList => hamdList;

  @override
  List<int> get maxPageCounters => List.filled(hamdList.length, 1);

  @override
  String get completionMessage => 'أنهيت قراءة رسائل الحمد';

  // @override
  // onPageChanged(int index) {
  //   currentPageIndex = index;
  //   update();
  // }

  // @override
  // goToHome() {
  //   Get.toNamed(AppRoute.hamd);
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
  //   return hamdList[index].duaText ?? '';
  // }
}
