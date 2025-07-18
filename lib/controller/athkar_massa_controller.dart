import 'dart:convert';
import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final String jsonString = await rootBundle.loadString('lib/core/data/json/adhkar_massa.json');
    adhkarMassaList = json.decode(jsonString);
    update();
  }

  @override
  List<int> get maxPageCounters {
    // Generate max counters dynamically from loaded data
    if (adhkarMassaList != null && adhkarMassaList!.isNotEmpty) {
      return adhkarMassaList!.map((item) => item['count'] as int? ?? 1).toList();
    }
    
    // Return default list if data not loaded yet
    return [
        1, // الحمدلله وحده
        1, // الكرسي
        3, // المعوذات
        1, // امسينا وامسى الملك
        1, // بك امسينا
        1, // سيد الاستغفار
        4, // امسيت اشهدك
        1, // ما امسى
        3, // عافني
        7, // حسبي الله
        1, // العفو والعافيه
        1, // عالم الغيب
        3, // بسم الله
        3, //رضيت
        1, // يا حي ياقيوم
        1, // امسينا
        1, // امسينا
        100, // سبحان الله وبحمده
        10, // لا اله الا الله
        100, // استغفر الله
        3, // اعوذ بكلمات الله
        10 // اللهم صلى
      ];
  }

  @override
  String get completionMessage => 'أنهيت قراءة أذكار المساء !';
}
