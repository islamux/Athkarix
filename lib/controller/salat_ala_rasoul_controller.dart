import 'package:athkarix/core/data/model/salat_ala_rasoul_list_model.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:get/get.dart';

abstract class SalatAlaRasoulAllahController extends GetxController {
  void goToHome(); // مؤقتا
  void increaseFontSize();
  void decreaseFontSize();
  void onPageChanged(int index);
  String getShareText(int index);
}

class SalatAlaRasoulAllahControllerImp extends SalatAlaRasoulAllahController {
  // Proberties
  int currentPageIndex = 0;
  int currentPageCounter = 0;
  double fontSize = 21.0;

  @override
  onPageChanged(int index) {
    currentPageIndex = index;
    update();
  }

  @override
  goToHome() {
    Get.toNamed(AppRoute.home);
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
    return salatAlaRasoulAllahList[index].duaText ?? '';
  }
}
