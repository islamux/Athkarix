import 'dart:convert';
import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AthkarIstiqadhControllerImp extends BaseAthkarController {
  // Instance from PageController to go to next page in pageview builder
  PageController pageControllerI = PageController();
  
  // The loaded adhkar list from JSON
  List<dynamic>? adhkarIstiqadhList;

  // Provide the specific PageController for this page
  @override
  PageController get pageController => pageControllerI;

  // Provide the completion message for this page
  @override
  String get completionMessage => 'أنهيت أذكار الاستيقاظ !';

  // Provide the specific data list for this page  
  @override
  List<dynamic> get dataList => adhkarIstiqadhList ?? [];
  
  @override
  void onInit() {
    super.onInit();
    loadAdhkarData();
  }
  
  // Load adhkar from the specific JSON file
  Future<void> loadAdhkarData() async {
    final String jsonString = await rootBundle.loadString('lib/core/data/json/adhkar_istiqadh.json');
    adhkarIstiqadhList = json.decode(jsonString);
    update();
  }

  // Provide the specific max counters for this page
  @override
  List<int> get maxPageCounters {
    // Generate max counters dynamically from loaded data
    if (adhkarIstiqadhList != null && adhkarIstiqadhList!.isNotEmpty) {
      return adhkarIstiqadhList!.map((item) => item['count'] as int? ?? 1).toList();
    }
    
    // Return default list if data not loaded yet
    return [1];
  }

  // Override for haptic feedback when completing an adhkar
  @override
  void increamentPageController() {
    currentPageCounter++;
    if (currentPageCounter >= maxPageCounters[currentPageIndex]) {
      currentPageIndex++;
      if (currentPageIndex < maxPageCounters.length) {
        currentPageCounter = 0;
        HapticFeedback.lightImpact();
        pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      } else {
        Get.snackbar('الحمدلله', completionMessage);
      }
    }
    update();
  }
}
