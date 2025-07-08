import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:athkarix/core/data/model/assma_hussna_model.dart';

class AssmaHussnaService {
  static const String _jsonPath = 'assets/json/assma-hussna.json';
  static List<AssmaHussnaModel>? _cachedData;

  // Load and parse JSON data
  static Future<List<AssmaHussnaModel>> loadAssmaHussnaData() async {
    // Return cached data if available
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      // Load JSON string from assets
      final jsonString = await rootBundle.loadString(_jsonPath);
      
      // Parse JSON string to List<dynamic>
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      // Convert to List<AssmaHussnaModel>
      _cachedData = jsonList
          .map((json) => AssmaHussnaModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return _cachedData!;
    } catch (e) {
      throw Exception('Failed to load Asma-ul-Husna data: $e');
    }
  }

  // Get a specific name by ID
  static Future<AssmaHussnaModel?> getAssmaHussnaById(int id) async {
    final data = await loadAssmaHussnaData();
    try {
      return data.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all names
  static Future<List<AssmaHussnaModel>> getAllAssmaHussna() async {
    return await loadAssmaHussnaData();
  }

  // Search names by Arabic name
  static Future<List<AssmaHussnaModel>> searchByName(String query) async {
    final data = await loadAssmaHussnaData();
    return data
        .where((item) => item.name.contains(query))
        .toList();
  }

  // Search names by description text
  static Future<List<AssmaHussnaModel>> searchByText(String query) async {
    final data = await loadAssmaHussnaData();
    return data
        .where((item) => item.text.contains(query))
        .toList();
  }

  // Get total count
  static Future<int> getCount() async {
    final data = await loadAssmaHussnaData();
    return data.length;
  }

  // Clear cache (useful for testing or refreshing data)
  static void clearCache() {
    _cachedData = null;
  }

  // Validate data integrity
  static Future<bool> validateData() async {
    try {
      final data = await loadAssmaHussnaData();
      
      // Check if we have the expected number of names (99 or 100)
      if (data.length != 99 && data.length != 100) {
        print('Warning: Expected 99 or 100 names, but found ${data.length}');
        return false;
      }

      // Check for duplicates
      final ids = data.map((item) => item.id).toSet();
      if (ids.length != data.length) {
        print('Warning: Duplicate IDs found in data');
        return false;
      }

      // Check for empty fields
      for (final item in data) {
        if (item.name.isEmpty || item.text.isEmpty) {
          print('Warning: Empty name or text found for ID ${item.id}');
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error validating data: $e');
      return false;
    }
  }
}
