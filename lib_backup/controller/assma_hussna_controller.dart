import 'package:athkarix/core/data/model/model_list/assma_hussna_list_model.dart';
import 'package:flutter/material.dart';
import 'package:athkarix/controller/base_athkar_controller.dart';

class AssmaHussnaControllerImp extends BaseAthkarController {
  final PageController pageControllerAssma = PageController();

  // new from clin ai
  @override
  PageController get pageController => pageControllerAssma;

  @override
  List<dynamic> get dataList => assmaHussnaList;

  @override
  List<int> get maxPageCounters => List.filled(assmaHussnaList.length, 1);

  @override
  String get completionMessage => 'أنهيت قراءة أسماء الله الحسنى !';
}
