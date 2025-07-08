import 'dart:convert';
import 'package:flutter/services.dart';

class JsonLoader {
  static Future<Map<String, dynamic>> loadJson(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString);
  }

  static Future<List<Map<String, dynamic>>> loadJsonList(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  }
}