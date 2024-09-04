import 'package:athkarix/core/data/model/model_list/dua_men_quran_list.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:get/get.dart';

abstract class DuaMenQuranController extends GetxController {
  next(); // tray to remove
  void duaMenSunnah();
  void goToHome();
  void increaseFontSize();
  void decreaseFontSize();
  void onPageChanged(int index);
  String getShareText(int index); // import estigfar list model to get text
}

class DuaMenQuranControllerImp extends DuaMenQuranController {
  // Proberties
  int currentPageIndex = 0;
  int currentPageCounter = 0;
  double fontsize = 21.0;

  @override
  duaMenSunnah() {}

  @override
  goToHome() {
    Get.toNamed(AppRoute.home);
  }

  @override
  onPageChanged(int index) {
    currentPageIndex = index;
    update();
  }

  @override
  next() {}

  @override
  decreaseFontSize() {
    fontsize -= 2;
    update();
  }

  @override
  increaseFontSize() {
    fontsize += 2;
    update();
  }

  @override
  String getShareText(int index) {
    return duaMenQuranList[index].duaText ?? '';
  }
}
