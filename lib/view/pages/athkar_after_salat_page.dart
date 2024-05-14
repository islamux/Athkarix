import 'package:athkarix/controller/athkar_after_salat_controller.dart';
import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/function/decrease_font.dart';
import 'package:athkarix/function/increase_font.dart';
import 'package:athkarix/view/widget/custom_floating_button.dart';
import 'package:athkarix/view/widget/custom_text_slider_athkar_after_salat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AthkarAfterSalat extends StatelessWidget {
  const AthkarAfterSalat({super.key});

  @override
  Widget build(BuildContext context) {
    // AthkarAfterSalatControllerImp controllerS =
    //     Get.put(AthkarAfterSalatControllerImp());
    final AthkarAfterSalatControllerImp controllerAfter =
        Get.find<AthkarAfterSalatControllerImp>();

    Get.find<FloatingButtonControllerImp>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              // share content by pass controlle as a parameter of current page
              onPressed: () => customShareContent(controllerAfter),
              icon: const Icon(Icons.share),
            ),
            const Center(
              child: Text(
                "أذكار بعد الصلاة",
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
            //Get.find<AthkarAfterSalatControllerImp>().resetCounter();

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
              decreaseFont(controllerAfter);
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
                increaseFont(controllerAfter);
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
              controllerAfter.increamentPageController();
            },
            child: const CustomTextSliderAthkarAfterSalat()),
      ),

      // Floating Buttons
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GetBuilder<FloatingButtonControllerImp>(
            builder: (context) {
              return GetBuilder<AthkarAfterSalatControllerImp>(
                  builder: (controllerAfter) {
                return CustomFloatingButton(
                  herotag: 'f2',
                  onPressed: () => controllerAfter.increamentPageController(),
                  text: Text(
                    '${controllerAfter.currentPageCounter}',
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
