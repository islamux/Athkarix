import 'package:athkarix/core/data/model/athkar_model.dart';
import 'package:athkarix/core/data/model/assma_hussna_model.dart';
import 'package:athkarix/core/data/service/assma_hussna_service.dart';

class AssmaHussnaDynamicListModel {
  static List<AthkarModel>? _cachedAthkarList;
  static List<AssmaHussnaModel>? _cachedAssmaHussnaList;

  /// Load Asma-ul-Husna data and convert to AthkarModel list
  static Future<List<AthkarModel>> getAthkarModelList() async {
    if (_cachedAthkarList != null) {
      return _cachedAthkarList!;
    }

    try {
      final assmaHussnaData = await AssmaHussnaService.getAllAssmaHussna();
      
      _cachedAthkarList = assmaHussnaData.map((item) => AthkarModel(
        duaText: _formatDuaText(item),
      )).toList();
      
      return _cachedAthkarList!;
    } catch (e) {
      throw Exception('Failed to load Asma-ul-Husna data for AthkarModel: $e');
    }
  }

  /// Load raw Asma-ul-Husna data
  static Future<List<AssmaHussnaModel>> getAssmaHussnaModelList() async {
    if (_cachedAssmaHussnaList != null) {
      return _cachedAssmaHussnaList!;
    }

    try {
      _cachedAssmaHussnaList = await AssmaHussnaService.getAllAssmaHussna();
      return _cachedAssmaHussnaList!;
    } catch (e) {
      throw Exception('Failed to load Asma-ul-Husna data: $e');
    }
  }

  /// Format the text for display in the UI
  static String _formatDuaText(AssmaHussnaModel item) {
    return '''[${item.name}]

${item.text}''';
  }

  /// Get a specific AthkarModel by index
  static Future<AthkarModel?> getAthkarModelByIndex(int index) async {
    try {
      final list = await getAthkarModelList();
      if (index >= 0 && index < list.length) {
        return list[index];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get a specific AssmaHussnaModel by ID
  static Future<AssmaHussnaModel?> getAssmaHussnaModelById(int id) async {
    try {
      final list = await getAssmaHussnaModelList();
      return list.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search Asma-ul-Husna by name
  static Future<List<AssmaHussnaModel>> searchByName(String query) async {
    try {
      final list = await getAssmaHussnaModelList();
      return list
          .where((item) => item.name.contains(query))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Search Asma-ul-Husna by text
  static Future<List<AssmaHussnaModel>> searchByText(String query) async {
    try {
      final list = await getAssmaHussnaModelList();
      return list
          .where((item) => item.text.contains(query))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get total count
  static Future<int> getCount() async {
    try {
      final list = await getAssmaHussnaModelList();
      return list.length;
    } catch (e) {
      return 0;
    }
  }

  /// Clear cache
  static void clearCache() {
    _cachedAthkarList = null;
    _cachedAssmaHussnaList = null;
    AssmaHussnaService.clearCache();
  }

  /// Refresh data
  static Future<void> refreshData() async {
    clearCache();
    await getAthkarModelList();
    await getAssmaHussnaModelList();
  }

  /// Validate data integrity
  static Future<bool> validateData() async {
    try {
      return await AssmaHussnaService.validateData();
    } catch (e) {
      return false;
    }
  }
}
