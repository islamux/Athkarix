import 'dart:convert';
import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DuaMenQuranControllerImp extends BaseAthkarController {
  final PageController pageControllerQuran = PageController();
  List<dynamic>? duaMenQuranList;

  @override
  void onInit() {
    super.onInit();
    loadAdhkarData();
  }

  Future<void> loadAdhkarData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/dua_men_quran.json');
      duaMenQuranList = json.decode(jsonString);
      update();
    } catch (e) {
      print('Error loading adhkar data: $e');
    }
  }

  @override
  PageController get pageController => pageControllerQuran;

  @override
  List<dynamic> get dataList => duaMenQuranList ?? [];

  @override
  List<int> get maxPageCounters => List.filled(duaMenQuranList?.length ?? 0, 1);

  @override
  String get completionMessage => 'أنهيت قراءة أدعية من القراءن !';
}
