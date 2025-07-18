import 'dart:convert';
import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class ComprehensiveAdhkarController extends BaseAthkarController {
  Future<List<dynamic>> loadAdhkarData();
}

class ComprehensiveAdhkarControllerImp extends ComprehensiveAdhkarController {
  List<dynamic>? adhkarList;
  final PageController _pageController = PageController();

  @override
  List<dynamic> get dataList => adhkarList ?? [];

  @override
  List<int> get maxPageCounters {
    if (adhkarList == null || adhkarList!.isEmpty) return [1];
    // Each item has a count of 1 for page turning
    return List.filled(adhkarList!.length, 1);
  }

  @override
  String get completionMessage => "تم الانتهاء من الأذكار الشاملة";

  @override
  PageController get pageController => _pageController;

  @override
  void onInit() {
    super.onInit();
    loadAdhkarData();
  }

  @override
  Future<List<dynamic>> loadAdhkarData() async {
    if (adhkarList == null) {
      adhkarList = [];
      
      // Load all adhkar from different JSON files
      final List<String> jsonFiles = [
        'lib/core/data/json/adhkar_sabah.json',
        'lib/core/data/json/adhkar_massa.json',
        'lib/core/data/json/adhkar_nawm.json',
        'lib/core/data/json/adhkar_istiqadh.json',
        'lib/core/data/json/adhkar_other.json'
      ];
      
      for (String jsonFile in jsonFiles) {
        try {
          final String jsonString = await rootBundle.loadString(jsonFile);
          final List<dynamic> categoryAdhkar = json.decode(jsonString);
          adhkarList!.addAll(categoryAdhkar);
        } catch (e) {
          // File might not exist, skip it
          print('Could not load $jsonFile: $e');
        }
      }
    }
    return adhkarList!;
  }

  @override
  String getShareText(int index) {
    if (adhkarList == null || index < 0 || index >= adhkarList!.length) {
      return '';
    }

    final adhkar = adhkarList![index];
    String shareText = adhkar['text'] ?? '';

    if (adhkar['description'] != null && adhkar['description'].isNotEmpty) {
      shareText += '\n\n${adhkar['description']}';
    }

    if (adhkar['reference'] != null && adhkar['reference'].isNotEmpty) {
      shareText += '\n\nالمصدر: ${adhkar['reference']}';
    }

    shareText += '\n\nعدد المرات: ${adhkar['count'] ?? 1}';

    return shareText;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
