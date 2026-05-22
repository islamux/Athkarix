import 'package:athkarix/core/data/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();

  final morningEnabled = false.obs;
  final eveningEnabled = false.obs;

  final morningHour = 8.obs;
  final morningMinute = 0.obs;
  final eveningHour = 17.obs;
  final eveningMinute = 0.obs;

  static const _keyMorningEnabled = 'notify_morning_enabled';
  static const _keyEveningEnabled = 'notify_evening_enabled';
  static const _keyMorningHour = 'notify_morning_hour';
  static const _keyMorningMinute = 'notify_morning_minute';
  static const _keyEveningHour = 'notify_evening_hour';
  static const _keyEveningMinute = 'notify_evening_minute';

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    morningEnabled.value = prefs.getBool(_keyMorningEnabled) ?? false;
    eveningEnabled.value = prefs.getBool(_keyEveningEnabled) ?? false;
    morningHour.value = prefs.getInt(_keyMorningHour) ?? 8;
    morningMinute.value = prefs.getInt(_keyMorningMinute) ?? 0;
    eveningHour.value = prefs.getInt(_keyEveningHour) ?? 17;
    eveningMinute.value = prefs.getInt(_keyEveningMinute) ?? 0;

    if (morningEnabled.value) {
      await _service.scheduleMorning(morningHour.value, morningMinute.value);
    }
    if (eveningEnabled.value) {
      await _service.scheduleEvening(eveningHour.value, eveningMinute.value);
    }
  }

  Future<void> setMorningEnabled(bool value) async {
    morningEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMorningEnabled, value);
    if (value) {
      await _service.scheduleMorning(morningHour.value, morningMinute.value);
    } else {
      await _service.cancelMorning();
    }
  }

  Future<void> setEveningEnabled(bool value) async {
    eveningEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEveningEnabled, value);
    if (value) {
      await _service.scheduleEvening(eveningHour.value, eveningMinute.value);
    } else {
      await _service.cancelEvening();
    }
  }

  Future<void> setMorningTime(TimeOfDay time) async {
    morningHour.value = time.hour;
    morningMinute.value = time.minute;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMorningHour, time.hour);
    await prefs.setInt(_keyMorningMinute, time.minute);
    if (morningEnabled.value) {
      await _service.scheduleMorning(time.hour, time.minute);
    }
  }

  Future<void> setEveningTime(TimeOfDay time) async {
    eveningHour.value = time.hour;
    eveningMinute.value = time.minute;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyEveningHour, time.hour);
    await prefs.setInt(_keyEveningMinute, time.minute);
    if (eveningEnabled.value) {
      await _service.scheduleEvening(time.hour, time.minute);
    }
  }
}
