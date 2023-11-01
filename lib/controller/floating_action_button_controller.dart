import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class FloatingButtonController extends GetxController {
  void increamentCouter();
  void increamentCounterUntil100();
  void reset();

  // TODO:
  void mekeVibrationEvery100();
  void mekeVibrationEvery1000();
}

class FloatingButtonControllerImp extends FloatingButtonController {
  //static final PageController pageControllerF = PageController();
  int currenPage = 0;
  int maxPage = 10;
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
      // Make vibiration to next zekr
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

  @override
  void mekeVibrationEvery100() {
    // to do later
  }

  @override
  void mekeVibrationEvery1000() {
    // To do later
  }
}
