import 'package:athkarix/controller/notification_controller.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: const Text(
          'إعدادات التنبيهات',
          style: TextStyle(color: AppColor.primaryColorGolden),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Get.back(),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildNotificationTile(
                context,
                icon: Icons.wb_sunny_outlined,
                title: 'تنبيه أذكار الصباح',
                subtitle: '${controller.morningHour.value.toString().padLeft(2, '0')}:${controller.morningMinute.value.toString().padLeft(2, '0')}',
                enabled: controller.morningEnabled,
                onToggle: (v) => controller.setMorningEnabled(v),
                onPickTime: () => _pickTime(context, controller, isMorning: true),
              ),
              const SizedBox(height: 16),
              _buildNotificationTile(
                context,
                icon: Icons.nights_stay_outlined,
                title: 'تنبيه أذكار المساء',
                subtitle: '${controller.eveningHour.value.toString().padLeft(2, '0')}:${controller.eveningMinute.value.toString().padLeft(2, '0')}',
                enabled: controller.eveningEnabled,
                onToggle: (v) => controller.setEveningEnabled(v),
                onPickTime: () => _pickTime(context, controller, isMorning: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required RxBool enabled,
    required ValueChanged<bool> onToggle,
    required VoidCallback onPickTime,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 40, color: AppColor.primaryColorGolden),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.goldenTheme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    subtitle,
                    style: AppTheme.goldenTheme.textTheme.bodyMedium?.copyWith(
                      color: enabled.value ? null : Colors.grey,
                    ),
                  )),
                ],
              ),
            ),
            Obx(() => enabled.value
              ? IconButton(
                  icon: const Icon(Icons.access_time, color: AppColor.primaryColorGolden),
                  onPressed: onPickTime,
                )
              : const SizedBox.shrink()),
            Obx(() => Switch(
              value: enabled.value,
              onChanged: onToggle,
              activeTrackColor: AppColor.primaryColorGolden,
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, NotificationController controller, {required bool isMorning}) async {
    final initial = TimeOfDay(
      hour: isMorning ? controller.morningHour.value : controller.eveningHour.value,
      minute: isMorning ? controller.morningMinute.value : controller.eveningMinute.value,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      if (isMorning) {
        await controller.setMorningTime(picked);
      } else {
        await controller.setEveningTime(picked);
      }
    }
  }
}
