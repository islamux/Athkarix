import 'dart:convert';
import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AthkarMassaControllerImp extends BaseAthkarController {
  // instance from PageController to go to next page in pageview builder.
  final PageController pageControllerM = PageController();
  
  // The loaded adhkar list from JSON
  List<dynamic>? adhkarMassaList;

  // new from clin ai
  @override
  PageController get pageController => pageControllerM;

  @override
  List<dynamic> get dataList => adhkarMassaList ?? [];
  
  @override
  void onInit() {
    super.onInit();
    loadAdhkarData();
  }
  
  // Load adhkar from the specific JSON file
  Future<void> loadAdhkarData() async {
    try {
      final String jsonString = await rootBundle.loadString('lib/core/data/json/adhkar_massa.json');
      adhkarMassaList = json.decode(jsonString);
      update();
    } catch (e) {
      print('Error loading adhkar data: $e');
    }
  }

  @override
  List<int> get maxPageCounters {
    // Generate max counters dynamically from loaded data
    if (adhkarMassaList != null && adhkarMassaList!.isNotEmpty) {
      return adhkarMassaList!.map((item) => item['count'] as int? ?? 1).toList();
    }
    
    // Return empty list if data not loaded yet
    return [];
  }

  @override
  String get completionMessage => 'أنهيت قراءة أذكار المساء !';
  
  // Override increamentPageController to handle JSON data properly
  @override
  void increamentPageController() {
    // Ensure data is loaded and valid
    if (adhkarMassaList == null || adhkarMassaList!.isEmpty || maxPageCounters.isEmpty) {
      return;
    }
    
    currentPageCounter++;
    if (currentPageCounter >= maxPageCounters[currentPageIndex]) {
      currentPageIndex++;
      if (currentPageIndex < maxPageCounters.length) {
        currentPageCounter = 0;
        HapticFeedback.vibrate();
        pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      } else {
        Get.snackbar('الحمدلله', completionMessage);
      }
    }
    update();
  }
  
  // Helper methods to access JSON data
  String getAthkarText(int index) {
    if (adhkarMassaList != null && index < adhkarMassaList!.length) {
      return adhkarMassaList![index]['text'] ?? '';
    }
    return '';
  }
  
  String getAthkarDescription(int index) {
    if (adhkarMassaList != null && index < adhkarMassaList!.length) {
      return adhkarMassaList![index]['description'] ?? '';
    }
    return '';
  }
  
  String getAthkarReference(int index) {
    if (adhkarMassaList != null && index < adhkarMassaList!.length) {
      return adhkarMassaList![index]['reference'] ?? '';
    }
    return '';
  }
  
  int getAthkarCount(int index) {
    if (adhkarMassaList != null && index < adhkarMassaList!.length) {
      return adhkarMassaList![index]['count'] ?? 1;
    }
    return 1;
  }
}
