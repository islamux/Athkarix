import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/controller/salat_ala_rasoul_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/core/utils/responsive_helper.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/view/widget/custom_floating_button.dart';
import 'package:athkarix/view/widget/custom_text_slider_salat_ala_rasoul.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalatAlaRasoulAllah extends StatelessWidget {
  const SalatAlaRasoulAllah({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalatAlaRasoulAllahControllerImp>();
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
              onPressed: () => customShareContent(controller),
              icon: Icon(
                Icons.share,
                size: ResponsiveHelper.scaledIconSize(context, 24),
              ),
            ),
            Center(
              child: Text(
                "الصلاة على النبي",
                style: TextStyle(
                    color: AppColor.primaryColorGolden,
                    fontSize: ResponsiveHelper.scaledFontSize(context, 20),
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
          child: Icon(
            Icons.arrow_back,
            color: Colors.amber,
            size: ResponsiveHelper.scaledIconSize(context, 24),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (fontControllerImp.fontSize > 15.0) {
                fontControllerImp.decreaseFontSize();
              }
            },
            icon: Icon(
              Icons.remove,
              color: Colors.amber,
              size: ResponsiveHelper.scaledIconSize(context, 24),
            ),
          ),
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
              if (fontControllerImp.fontSize <= 37.0) {
                fontControllerImp.increaseFontSize();
              }
            },
            icon: Icon(
              Icons.add,
              color: Colors.amber,
              size: ResponsiveHelper.scaledIconSize(context, 24),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              Feedback.forTap(context);
              floatingController.increamentCouter();
            },
            child: const CustomTextSliderSalatAlaRasoul()),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GetBuilder<FloatingButtonControllerImp>(builder: (_) {
            return Builder(builder: (ctx) {
              return CustomFloatingButton(
                herotag: 'f2',
                onPressed: () => floatingController.increamentCounterUntil100(),
                text: Text(
                  '${floatingController.counter}',
                  style: AppTheme.goldenTheme.textTheme.titleMedium?.copyWith(
                    fontSize: ResponsiveHelper.scaledFontSize(ctx, 21),
                  ),
                ),
              );
            });
          }),
          GetBuilder<FloatingButtonControllerImp>(builder: (_) {
            return Builder(builder: (ctx) {
              return CustomFloatingButton(
                herotag: 'f3',
                onPressed: () => floatingController.reset(),
                text: Text(
                  'تصفير',
                  style: AppTheme.goldenTheme.textTheme.titleMedium?.copyWith(
                    fontSize: ResponsiveHelper.scaledFontSize(ctx, 21),
                  ),
                ),
              );
            });
          })
        ],
      ),
    );
  }
}
