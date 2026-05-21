import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class FloatingButtonController extends GetxController {
  void increamentCouter();
  void increamentCounterUntil100();
  void reset();
}

class FloatingButtonControllerImp extends FloatingButtonController {
  int counter = 0;
  @override
  void increamentCouter() {
    counter++;
    update();
  }

  @override
  void increamentCounterUntil100() {
    counter++;
    if (counter == 100) {
      counter = 1;
      HapticFeedback.vibrate();
    }

    update();
  }

  @override
  void reset() {
    counter = 0;
    update();
  }
}
