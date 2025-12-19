import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/controller/tasbih_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/view/widget/custom_floating_button.dart';
import 'package:athkarix/view/widget/custom_text_slider_tasbih.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tasbih extends StatelessWidget {
  const Tasbih({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Inject controller
    final controller = Get.find<TasbihControllerImp>();
    //TasbihControllerImp controller = Get.put(TasbihControllerImp());
    FloatingButtonControllerImp floatingController =
        Get.put(FloatingButtonControllerImp());

    final FontControllerImp fontControllerImp = Get.find<FontControllerImp>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              // share content by pass controlle as a parameter of current page
              onPressed: () => customShareContent(controller),
              icon: const Icon(Icons.share),
            ),
            const Center(
              child: Text(
                "تسبيح       ",
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
              )),
          // Font between + -
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "الخط",
                style: TextStyle(
                  color: AppColor.primaryColorGolden,
                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                ),
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
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Feedback.forTap(context);
            floatingController.increamentCouter();
          },
          child: const CustomTextSliderTasbih(),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
