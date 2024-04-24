import 'package:athkarix/controller/assma_hussna_controller.dart';
import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/function/decrease_font.dart';
import 'package:athkarix/function/increase_font.dart';
import 'package:athkarix/view/widget/assmahussna/custom_text_slider_assma_hussna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssmaHussna extends StatelessWidget {
  const AssmaHussna({super.key});

  @override
  Widget build(BuildContext context) {
    final AssmaHussnaControllerImp controllerAs =
        Get.find<AssmaHussnaControllerImp>();
    //AssmaHussnaControllerImp controllerAs = Get.put(AthkarSabahControllerImp());
    Get.put(FloatingButtonControllerImp());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              // share content by pass controlle as a parameter of current page
              onPressed: () => customShareContent(controllerAs),
              icon: const Icon(Icons.share),
            ),
            const Center(
              child: Text(
                "الأسماء الحسنى    ",
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
            Get.find<AssmaHussnaControllerImp>().resetCounter();
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
              decreaseFont(controllerAs);

              // if (controllerAs.fontSize > 21.0) {
              //   controllerAs.decreaseFontSize();
              //   if (kDebugMode) {
              //     print("Font size :${controllerAs.fontSize}");
              //   }
              // }
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
                increaseFont(controllerAs);

                // if (controllerAs.fontSize <= 37.0) {
                //   controllerAs.increaseFontSize();
                //   if (kDebugMode) {
                //     print("Font size :${controllerAs.fontSize}");
                //   }
                // }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.amber,
              ))
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomTextSliderAssmaHussna(),
            ),
            // Slider to control the page

            // Scroll down indicator to tell user scroll down to reach to the end of txt
          ],
        ),
      ),
    );
  }
}
