import 'package:athkarix/controller/athkar_sabah_controller.dart';
import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/view/widget/custom_floating_button.dart';
import 'package:athkarix/view/widget/custom_text_slider_athkar_sabah.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AthkarSabah extends StatelessWidget {
  const AthkarSabah({super.key});

  @override
  Widget build(BuildContext context) {
    final AthkarSabahControllerImp controllerS =
        Get.find<AthkarSabahControllerImp>();
    //AthkarSabahControllerImp controllerS = Get.put(AthkarSabahControllerImp());
    Get.put(FloatingButtonControllerImp());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              // share content by pass controlle as a parameter of current page
              onPressed: () => customShareContent(controllerS),
              icon: const Icon(Icons.share),
            ),
            const Center(
              child:  Text(
                "أذكار الصباح",
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
            Get.find<AthkarSabahControllerImp>().resetCounter();
            Get.toNamed(AppRoute.home);
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              controllerS.decreaseFontSize();
            },
            icon: const Icon(Icons.remove),
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
                controllerS.increaseFontSize();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              // test adding sound when tap
              Feedback.forTap(context);
              controllerS.increamentPageController();
            },
            child: const CustomTextSliderAthkarSabah()),
      ),

      // Floating Buttons
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GetBuilder<FloatingButtonControllerImp>(
            builder: (context) {
              return GetBuilder<AthkarSabahControllerImp>(builder: (context) {
                return CustomFloatingButton(
                  herotag: 'f2',
                  onPressed: () => controllerS.increamentPageController(),
                  text: Text(
                    '${controllerS.currentPageCounter}',
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
