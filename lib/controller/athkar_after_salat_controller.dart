import 'dart:convert';
import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AthkarAfterSalatControllerImp extends BaseAthkarController {
  // instance from PageController to go to next page in pageview builder.
  PageController pageControllerS = PageController();
  List<dynamic>? adhkarAfterSalatList;

  @override
  void onInit() {
    super.onInit();
    loadAdhkarData();
  }

  Future<void> loadAdhkarData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/athkar_after_salat.json');
      adhkarAfterSalatList = json.decode(jsonString);
      update();
    } catch (e) {
      print('Error loading adhkar data: $e');
    }
  }

  @override
  String get completionMessage => 'أنهيت قراءة أذكار مابعد الصلاة';

  @override
  List get dataList => adhkarAfterSalatList ?? [];

  @override
  List<int> get maxPageCounters {
    if (adhkarAfterSalatList != null && adhkarAfterSalatList!.isNotEmpty) {
      return adhkarAfterSalatList!.map((item) => item['count'] as int? ?? 1).toList();
    }
    return [];
  }

  @override
  PageController get pageController => pageControllerS;
}
