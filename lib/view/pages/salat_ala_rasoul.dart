import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/controller/salat_ala_rasoul_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/view/widget/custom_floating_button.dart';
import 'package:athkarix/view/widget/custom_text_slider_salat_ala_rasoul.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/data/static/theme/app_them.dart';

class SalatAlaRasoulAllah extends StatelessWidget {
  const SalatAlaRasoulAllah({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Inject controller
    // SalatAlaRasoulAllahControllerImp controller =
    //     Get.put(SalatAlaRasoulAllahControllerImp());

    final controller = Get.find<SalatAlaRasoulAllahControllerImp>();

    FloatingButtonControllerImp floatingController =
        Get.put(FloatingButtonControllerImp());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => customShareContent(controller),
              icon: const Icon(Icons.share),
            ),
            const Center(
              child: Text(
                "الصلاة على النبي",
                style: TextStyle(
                    color: AppColor.primaryColorGolden,
                    fontSize: 20,
                    backgroundColor: AppColor.primaryColorBlack2),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.toNamed(AppRoute.home);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.amber,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (controller.fontSize > 15.0) {
                  controller.decreaseFontSize();
                }
              },
              icon: const Icon(
                Icons.remove,
                color: Colors.amber,
              )),
          // Font between + -
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "الخط",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  color: AppColor.primaryColorGolden,
                ),
              ),
            ],
          ),

          IconButton(
              onPressed: () {
                if (controller.fontSize <= 37.0) {
                  controller.increaseFontSize();
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.amber,
              ))
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              Feedback.forTap(context);
              floatingController.increamentCouter();
            },
            child: const CustomTextSliderSalatAlaRasoulAllah()),
      ),

      // floating button
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // Floating 1
        children: [
          // Floating 2
          GetBuilder<FloatingButtonControllerImp>(builder: (context) {
            return CustomFloatingButton(
              herotag: 'f2',
              onPressed: () => floatingController.increamentCounterUntil100(),
              text: Text(
                '${floatingController.counter}',
                style: AppTheme.goldenTheme.textTheme.titleMedium,
              ),
            );
          }),
          //Floating تصفير
          GetBuilder<FloatingButtonControllerImp>(builder: (context) {
            return CustomFloatingButton(
              herotag: 'f3',
              onPressed: () => floatingController.reset(),
              text: Text(
                'تصفير',
                style: AppTheme.goldenTheme.textTheme.titleMedium,
              ),
            );
          })
        ],
      ),
    );
  }
}
