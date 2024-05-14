import 'package:flutter/foundation.dart';

decreaseFont(controller) {
  if (controller.fontSize > 21.0) {
    controller.decreaseFontSize();
    if (kDebugMode) {
      print("Font size :${controller.fontSize}");
    }
  }
}
