import 'package:get/get.dart';

import '../core/data/static/routes_constant.dart';

abstract class HomeController extends GetxController {
  goToAthkarSabah();
  goToAthkarMassa();
  goToTasbih();
  goToEstigfar();
  goToHamd();
  goToSalatAlaRasoulAllah();
  goToDuaMenSunnah();
  goToDuaMenQuran();
  goToAthkarAfterSalat();
  goToAssmaHussna();
  goToAthkarBeforeGoToBed();
}

class HomeControllerImp extends HomeController {

  @override
  goToAthkarMassa() {
    Get.toNamed(AppRoute.athkarMassa);
  }

  @override
  goToAthkarSabah() {
    Get.toNamed(AppRoute.athkarSabah);
  }

  @override
  goToEstigfar() {
    Get.toNamed(AppRoute.estigfar);
  }

  @override
  goToHamd() {
    Get.toNamed(AppRoute.hamd);
  }

  @override
  goToSalatAlaRasoulAllah() {
    Get.toNamed(AppRoute.salatAlaRasoulAllah);
  }

  @override
  goToTasbih() {
    Get.toNamed(AppRoute.tasbih);
  }

  @override
  goToDuaMenQuran() {
    Get.toNamed(AppRoute.duaMenQuran);
  }

  @override
  goToDuaMenSunnah() {
    Get.toNamed(AppRoute.duaMenSunnah);
  }

  @override
  goToAthkarAfterSalat() {
    Get.toNamed(AppRoute.athkarAfterSalat);
  }

  @override
  goToAssmaHussna() {
    Get.toNamed(AppRoute.assmaHussna);
  }

  @override
  goToAthkarBeforeGoToBed() {
    Get.toNamed(AppRoute.athkarBeforeGoToBed);
  }
}
