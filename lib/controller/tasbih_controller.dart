import 'package:athkarix/core/data/model/model_list/tasbih_list_model.dart';
import 'package:get/get.dart';

abstract class TasbihController extends GetxController {
  //next(); // when click on button go to next page in pageview
  //void goToHome(); // مؤقتا
  void increaseFontSize();
  void decreaseFontSize();
  void increamentCounter();
  void resetCounter();
  void onPageChanged(int index);
  String getShareText(int index);
}

class TasbihControllerImp extends TasbihController {
  // Proberties
  int currentPageIndex = 0;
  int currentPageCounter = 0;
  double fontSize = 21.0;
  int counter = 0;

  @override
  onPageChanged(int index) {
    currentPageIndex = index;
    update();
  }

  @override
  increaseFontSize() {
    fontSize += 2.0;
    update();
  }

  @override
  decreaseFontSize() {
    fontSize -= 2.0;
    update();
  }

  @override
  increamentCounter() {
    counter++;
  }

  @override
  resetCounter() {
    counter = 0;
  }

  @override
  String getShareText(int index) {
    // import tasbihList
    return tasbihList[index].duaText ?? '';
  }
}
