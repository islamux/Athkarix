import 'package:athkarix/controller/assma_hussna_controller.dart';
import 'package:athkarix/controller/athkar_after_salat_controller.dart';
import 'package:athkarix/controller/athkar_before_go_to_bed_controller.dart';
import 'package:athkarix/controller/athkar_massa_controller.dart';
import 'package:athkarix/controller/athkar_sabah_controller.dart';
import 'package:athkarix/controller/athkar_nawm_controller.dart';
import 'package:athkarix/controller/athkar_istiqadh_controller.dart';
import 'package:athkarix/controller/athkar_other_controller.dart';
import 'package:athkarix/controller/comprehensive_adhkar_controller.dart';
import 'package:athkarix/controller/duaa_men_quran_controller.dart';
import 'package:athkarix/controller/duaa_men_sunnah_controller.dart';
import 'package:athkarix/controller/estigfar_controller.dart';
import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/controller/hamd_controller.dart';
import 'package:athkarix/controller/home_controller.dart';
import 'package:athkarix/controller/salat_ala_rasoul_controller.dart';
import 'package:athkarix/controller/tasbih_controller.dart';
import 'package:athkarix/controller/font_controller.dart'; // Add this import
import 'package:get/get.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize FontControllerImp
    Get.put(FontControllerImp()); // Add this line
    // binding Page controller
    Get.put(EstigfarControllerImp());
    Get.put(TasbihControllerImp());
    Get.put(HamdControllerImp());
    Get.put(AthkarSabahControllerImp());
    Get.put(AthkarMassaControllerImp());
    Get.put(AthkarAfterSalatControllerImp());
    Get.put(DuaMenSunnahControllerImp());
    Get.put(DuaMenQuranControllerImp());
    Get.put(SalatAlaRasoulAllahControllerImp());
    Get.put(HomeControllerImp());
    Get.put(AssmaHussnaControllerImp());
    Get.put(AthkarBeforeGoToBedControllerImp());
    Get.put(ComprehensiveAdhkarControllerImp());
    Get.put(AthkarNawmControllerImp());
    Get.put(AthkarIstiqadhControllerImp());
    Get.put(AthkarOtherControllerImp());
    Get.put(FloatingButtonControllerImp());
  }
}
