import 'package:athkarix/core/data/service/assma_hussna_service.dart';
import 'package:athkarix/core/data/model/assma_hussna_model.dart';
import 'package:athkarix/core/data/model/athkar_model.dart';
import 'package:athkarix/core/data/model/model_list/assma_hussna_list_model.dart';
import 'package:flutter/material.dart';
import 'package:athkarix/controller/base_athkar_controller.dart';
import 'package:get/get.dart';

class AssmaHussnaControllerImp extends BaseAthkarController {
  final PageController pageControllerAssma = PageController();
  
  // Loading state
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Data storage
  List<AssmaHussnaModel> assmaHussnaData = [];
  List<AthkarModel> _athkarModelList = [];

  @override
  void onInit() {
    super.onInit();
    loadAssmaHussnaData();
  }

  // Load data from JSON
  Future<void> loadAssmaHussnaData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      // Load data from service
      assmaHussnaData = await AssmaHussnaService.getAllAssmaHussna();
      
      // Convert to AthkarModel for compatibility with existing UI
      _athkarModelList = assmaHussnaData.map((item) => AthkarModel(
        duaText: '[${item.name}]\n\n${item.text}',
      )).toList();
      
      // Validate data
      final isValid = await AssmaHussnaService.validateData();
      if (!isValid) {
        print('Warning: Data validation failed');
      }
      
      isLoading.value = false;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      isLoading.value = false;
      
      // Fallback to static data if JSON loading fails
      print('Error loading JSON data: $e');
      print('Falling back to static data...');
      _athkarModelList = assmaHussnaList; // Use existing static data as fallback
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    AssmaHussnaService.clearCache();
    await loadAssmaHussnaData();
  }

  @override
  PageController get pageController => pageControllerAssma;

  @override
  List<dynamic> get dataList => _athkarModelList;

  @override
  List<int> get maxPageCounters => List.filled(_athkarModelList.length, 1);

  @override
  String get completionMessage => 'أنهيت قراءة أسماء الله الحسنى !';
  
  // Get specific Asma-ul-Husna by ID
  AssmaHussnaModel? getAssmaHussnaById(int id) {
    try {
      return assmaHussnaData.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Search functionality
  List<AssmaHussnaModel> searchByName(String query) {
    return assmaHussnaData
        .where((item) => item.name.contains(query))
        .toList();
  }
  
  List<AssmaHussnaModel> searchByText(String query) {
    return assmaHussnaData
        .where((item) => item.text.contains(query))
        .toList();
  }

  @override
  void onClose() {
    pageControllerAssma.dispose();
    super.onClose();
  }
}
