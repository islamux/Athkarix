import 'package:athkarix/core/data/model/model_list/hamd_list_model.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:get/get.dart';

abstract class HamdController extends GetxController {
  next(); // when click on button go to next page in pageview
  void onPageChanged(int index);
  void goToHome(); // مؤقتا
  void increaseFontSize();
  void decreaseFontSize();
  String getShareText(int index);
}

class HamdControllerImp extends HamdController {
  // Proberties
  int currentPageIndex = 0;
  int currentPageCounter = 0;
  double fontSize = 29.0;

  @override
  next() {}

  @override
  onPageChanged(int index) {
    currentPageIndex = index;
    update();
  }

  @override
  goToHome() {
    Get.toNamed(AppRoute.hamd);
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
  String getShareText(int index) {
    return hamdList[index].duaText ?? '';
  }
}
