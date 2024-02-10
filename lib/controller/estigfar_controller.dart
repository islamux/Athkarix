import 'package:athkarix/core/data/model/estigfar_list_model.dart';
import 'package:get/get.dart';

abstract class EstigfarController extends GetxController {
  // to reset counter when go to any page

  void goToHome();
  void increaseFontSize();
  void decreaseFontSize();
  void onPageChanged(int index);
  String getShareText(int index);
  // TODO:
  void mekeVibrationEvery100();
  void mekeVibrationEvery1000();
// Favorite Func
}

class EstigfarControllerImp extends EstigfarController {
  double fontSize = 21.0;
  int currentPageIndex = 0;
  int currentPageCounter = 0;

  @override
  void onPageChanged(int index) {
    currentPageIndex = index;
    update();
  }

  @override
  void increaseFontSize() {
    fontSize += 2.0;
    update();
  }

  @override
  void decreaseFontSize() {
    fontSize -= 2.0;
    update();
  }

  @override
  void goToHome() {}

  @override
  String getShareText(int index) {
    return estigfarList[index].duaText ?? '';
  }

  @override
  void mekeVibrationEvery100() {
    // TODO: implement mekeVibrationEvery100
  }

  @override
  void mekeVibrationEvery1000() {
    // TODO: implement mekeVibrationEvery1000
  }
}
