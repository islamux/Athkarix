import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/view/pages/assma_hussna_page.dart';
import 'package:athkarix/view/pages/athkar_before_.go_to_bed.dart';
import 'package:athkarix/view/pages/comprehensive_adhkar.dart';
import 'package:athkarix/view/pages/dua_men_quran.dart';
import 'package:athkarix/view/pages/estigfar.dart';
import 'package:athkarix/view/pages/hamd.dart';
import 'package:athkarix/view/pages/home.dart';
import 'package:athkarix/view/pages/salat_ala_rasoul.dart';
import 'package:athkarix/view/pages/tasbih.dart';
import 'package:get/get.dart';

import 'view/pages/athkar_after_salat_page.dart';
import 'view/pages/athkar_massa_page.dart';
import 'view/pages/athkar_sabah_page.dart';
import 'view/pages/dua_men_sunnah.dart';
import 'view/pages/athkar_nawm_page.dart';
import 'view/pages/athkar_istiqadh_page.dart';
import 'view/pages/athkar_other_page.dart';

List<GetPage<dynamic>> routes = [
  GetPage(name: AppRoute.athkarSabah, page: (() => const AthkarSabah())),
  GetPage(name: AppRoute.athkarMassa, page: () => const AthkarMassa()),
  GetPage(
      name: AppRoute.athkarAfterSalat, page: (() => const AthkarAfterSalat())),
  GetPage(
      name: AppRoute.salatAlaRasoulAllah,
      page: (() => const SalatAlaRasoulAllah())),
  GetPage(name: AppRoute.home, page: (() => const Home())),
  GetPage(name: AppRoute.hamd, page: (() => const Hamd())),
  GetPage(name: AppRoute.estigfar, page: (() => const Estigfar())),
  GetPage(name: AppRoute.hamd, page: (() => const Hamd())),
  GetPage(name: AppRoute.tasbih, page: (() => const Tasbih())),
  GetPage(name: AppRoute.duaMenQuran, page: (() => const DuaMenQuran())),
  GetPage(name: AppRoute.duaMenSunnah, page: (() => const DuaMenSunnah())),
  GetPage(name: AppRoute.assmaHussna, page: (() => const AssmaHussna())),
  GetPage(
      name: AppRoute.athkarBeforeGoToBed,
      page: (() => const AthkarBeforeGoToBed())),
  GetPage(
      name: AppRoute.comprehensiveAdhkar,
      page: (() => const ComprehensiveAdhkar())),
  GetPage(name: AppRoute.athkarNawm, page: (() => const AthkarNawm())),
  GetPage(name: AppRoute.athkarIstiqadh, page: (() => const AthkarIstiqadh())),
  GetPage(name: AppRoute.athkarOther, page: (() => const AthkarOther())),
//  GetPage(name: AppRoute.catalogue, page: (() => CataloguePage())),
];
