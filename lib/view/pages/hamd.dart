import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/controller/hamd_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/view/widget/custom_floating_button.dart';
import 'package:athkarix/view/widget/custom_text_slide_hamd.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/data/static/theme/app_them.dart';

class Hamd extends StatelessWidget {
  const Hamd({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Inject controller
    //HamdControllerImp controller = Get.put(HamdControllerImp());
    final HamdControllerImp controller = Get.find<HamdControllerImp>();
    final FloatingButtonControllerImp floatingController =
        Get.find<FloatingButtonControllerImp>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => customShareContent(controller),
                icon: const Icon(Icons.share)),
            const Center(
              child:  Text(
                "الحمد",
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
            Get.toNamed(AppRoute.home);
          },
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.decreaseFontSize();
              },
              icon: const Icon(Icons.remove)),
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
                controller.increaseFontSize();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              Feedback.forTap(context);
              floatingController.increamentCouter();
            },
            child: const CustomTextSliderHamd()),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GetBuilder<FloatingButtonControllerImp>(builder: (context) {
            return CustomFloatingButton(
              herotag: 'f2',
              onPressed: () => floatingController.increamentCouter(),
              text: Text(
                '${floatingController.counter}',
                style: AppTheme.goldenTheme.textTheme.titleMedium,
              ),
            );
          }),
          GetBuilder<FloatingButtonControllerImp>(builder: (context) {
            return CustomFloatingButton(
              herotag: 'f3',
              onPressed: () => floatingController.reset(),
              text: Text(
                'تصفير',
                style: AppTheme.goldenTheme.textTheme.titleMedium,
              ),
            );
          }),
        ],
      ),
    );
  }
}
