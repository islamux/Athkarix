import 'package:get/get.dart';

import '../core/data/static/routes_constant.dart';

abstract class HomeController extends GetxController {
  goToAthkarSabah();
  goToAthkarMassa();
  goToTasbih();
  goToEstigfar();
  goToHamd();
  goToSalatAlaRasoulAllah();
  goToSalatDuha();
  goToDuaMenSunnah();
  goToDuaMenQuran();
  goToAthkarAfterSalat();
  goToAssmaHussna();
  goToAthkarBeforeGoToBed();
  goToCatalogue();
}

class HomeControllerImp extends HomeController {
  // My special athkar
  var myAthkarList = RxList<String>([]); // to do | not working yet
  List<String> pages =
      List.generate(210, (index) => 'Page ${index + 1}'); // tesing

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
  goToSalatDuha() {
    Get.toNamed(AppRoute.salatDuha);
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

  @override
  goToCatalogue() {
    Get.toNamed(AppRoute.catalogue);
  }
}
