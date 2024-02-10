import 'package:athkarix/controller/athkar_massa_controller.dart';
import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/view/widget/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/custom_text_slider_athkar_mass.dart';

class AthkarMassa extends StatelessWidget {
  const AthkarMassa({super.key});

  @override
  Widget build(BuildContext context) {
    //AthkarMassaControllerImp controllerM = Get.put(AthkarMassaControllerImp());
    final controllerM = Get.find<AthkarMassaControllerImp>();
    Get.put(FloatingButtonControllerImp());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              // share content by pass controlle as a parameter of current page
              onPressed: () => customShareContent(controllerM),
              icon: const Icon(Icons.share),
            ),
            const Center(
              child: Text(
                "أذكار المساء",
                style: TextStyle(
                    color: AppColor.primaryColorGolden,
                    backgroundColor: AppColor.primaryColorBlack2),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            // reset before return to home page
            Get.find<AthkarMassaControllerImp>().resetCounter();
            //controllerM.resetCounter();
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
              controllerM.decreaseFontSize();
            },
            icon: const Icon(
              Icons.remove,
              color: Colors.amber,
            ),
          ),

          // Font between + -
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "الخط",
                style: TextStyle(color: AppColor.primaryColorGolden),
              ),
            ],
          ),

          IconButton(
              onPressed: () {
                controllerM.increaseFontSize();
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
              // test adding sound when tap
              Feedback.forTap(context);
              controllerM.increamentPageController();
            },
            child: const CustomTextSliderAthkarMassa()),
      ),

      // Floating Buttons
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GetBuilder<FloatingButtonControllerImp>(
            builder: (context) {
              return GetBuilder<AthkarMassaControllerImp>(builder: (context) {
                return CustomFloatingButton(
                  herotag: 'f2',
                  onPressed: () => controllerM.increamentPageController(),
                  text: Text(
                    '${controllerM.currentPageCounter}',
                    style: AppTheme.goldenTheme.textTheme.titleMedium,
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
