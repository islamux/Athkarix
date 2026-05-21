import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/controller/athkar_sabah_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Routes', () {
    test('all route constants have unique values', () {
      final routes = <String>{
        AppRoute.home,
        AppRoute.athkarSabah,
        AppRoute.athkarMassa,
        AppRoute.estigfar,
        AppRoute.tasbih,
        AppRoute.hamd,
        AppRoute.salatAlaRasoulAllah,
        AppRoute.duaMenQuran,
        AppRoute.duaMenSunnah,
        AppRoute.athkarAfterSalat,
        AppRoute.assmaHussna,
        AppRoute.athkarBeforeGoToBed,
      };

      expect(routes.length, equals(12), reason: 'All routes must be unique');
    });
  });

  group('Controllers', () {
    test('AthkarSabahControllerImp disposes PageController on close without error', () {
      final controller = AthkarSabahControllerImp();
      final pageController = controller.pageController;

      expect(pageController.hasClients, isFalse);

      controller.onClose();

      expect(pageController.hasClients, isFalse,
          reason: 'After onClose, PageController remains disposed');
    });

    test('AthkarSabahControllerImp has correct default values', () {
      final controller = AthkarSabahControllerImp();

      expect(controller.currentPageIndex, equals(0));
      expect(controller.currentPageCounter.value, equals(0));
      expect(controller.completionMessage, isNotEmpty);
      expect(controller.maxPageCounters.length, greaterThan(0));
      expect(controller.dataList.length,
          equals(controller.maxPageCounters.length));
    });
  });
}
