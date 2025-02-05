import 'package:athkarix/core/data/model/model_list/estigfar_list_model.dart';
import 'package:get/get.dart';

abstract class EstigfarController extends GetxController {
  // to reset counter when go to any page

  void goToHome();
  void increaseFontSize();
  void decreaseFontSize();
  void onPageChanged(int index);
  String getShareText(int index);
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
}
