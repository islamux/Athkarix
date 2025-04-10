import 'package:get/get.dart';

abstract class FontController extends GetxController {
  void changeFont(String font);
  void increaseFontSize();
  void decreaseFontSize();
}

class FontControllerImp extends FontController {
  // Make fontSize reactive
  final RxDouble fontSize = 28.6.obs; // Updated default font size
  // Keep track of the selected font family
  final RxString selectFont = "Amiri".obs;

  // Define boundaries
  final double maxFontSize = 37.0;
  final double minFontSize = 21.0; // Based on decreaseFont logic

  @override
  void changeFont(Object? font) {
    if (font is String) {
      selectFont.value = font;
    }
  }

  @override
  void increaseFontSize() {
    // Increase font size, respecting the maximum limit
    if (fontSize.value < maxFontSize) {
      fontSize.value += 2.0;
      // Ensure it doesn't exceed max exactly if step is large
      if (fontSize.value > maxFontSize) {
        fontSize.value = maxFontSize;
      }
    }
    // update() is not needed for .obs variables when using Obx
  }

  @override
  void decreaseFontSize() {
    // Decrease font size, respecting the minimum limit
    if (fontSize.value > minFontSize) {
      fontSize.value -= 2.0;
      // Ensure it doesn't go below min exactly if step is large
      if (fontSize.value < minFontSize) {
        fontSize.value = minFontSize;
      }
    }
    // update() is not needed for .obs variables when using Obx
  }
}
