import 'package:athkarix/controller/athkar_before_go_to_bed_controller.dart';
import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/view/widget/custom_floating_button.dart';
import 'package:athkarix/view/widget/custom_text_slider_athkar_before_go_to_bed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AthkarBeforeGoToBed extends StatelessWidget {
  const AthkarBeforeGoToBed({super.key});

  @override
  Widget build(BuildContext context) {
    // AthkarBeforeGoToBedControllerImp controllerS =
    //     Get.put(AthkarBeforeGoToBedControllerImp());
    final AthkarBeforeGoToBedControllerImp controllerBefore =
        Get.find<AthkarBeforeGoToBedControllerImp>();

    Get.find<FloatingButtonControllerImp>();
    final FontControllerImp fontControllerImp = Get.find<FontControllerImp>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              // share content by pass controlle as a parameter of current page
              onPressed: () => customShareContent(controllerBefore),
              icon: const Icon(Icons.share),
            ),
            const Center(
              child: Text(
                "أذكار النوم ",
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
            //Get.find<AthkarBeforeGoToBedControllerImp>().resetCounter();

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
              if (fontControllerImp.fontSize > 15.0) {
                fontControllerImp.decreaseFontSize();
              }
            },
            icon: const Icon(
              Icons.remove,
              color: Colors.amber,
            ),
          ),
          // Font between + -
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "الخط",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                    color: AppColor.primaryColorGolden),
              ),
            ],
          ),

          IconButton(
              onPressed: () {
                if (fontControllerImp.fontSize <= 37.0) {
                  fontControllerImp.increaseFontSize();
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.amber,
              ))
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [Expanded(child: CustomTextSliderAthkarBeforeGoToBed())],
        ),
      ),

      // Floating Buttons
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GetBuilder<FloatingButtonControllerImp>(
            builder: (context) {
              return GetBuilder<AthkarBeforeGoToBedControllerImp>(
                  builder: (controllerBefore) {
                return CustomFloatingButton(
                  herotag: 'f2',
                  onPressed: () => controllerBefore.increamentPageController(),
                  text: Text(
                    '${controllerBefore.currentPageCounter}',
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
