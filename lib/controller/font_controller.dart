import 'package:get/get.dart';

abstract class FontController extends GetxController {
  void changeFont(String font);
  void increaseFontSize();
  void decreaseFontSize();
}

class FontControllerImp extends FontController {
  final selectFont = "Amiri".obs;
  double fontSize = 21.0;

  @override
  void changeFont(Object? font) {
    if (font is String) {
      selectFont.value = font;
    }
  }

  @override
  void decreaseFontSize() {
    fontSize += 2.0;
    update();
  }

  @override
  void increaseFontSize() {
    fontSize -= 2.0;
    update();
  }
}
