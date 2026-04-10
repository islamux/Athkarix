import 'package:athkarix/controller/athkar_after_salat_controller.dart';
import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/core/utils/responsive_helper.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/view/widget/custom_floating_button.dart';
import 'package:athkarix/view/widget/custom_text_slider_athkar_after_salat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AthkarAfterSalat extends StatelessWidget {
  const AthkarAfterSalat({super.key});

  @override
  Widget build(BuildContext context) {
    final AthkarAfterSalatControllerImp controllerAfter =
        Get.find<AthkarAfterSalatControllerImp>();

    Get.find<FloatingButtonControllerImp>();
    FontControllerImp fontControllerImp = Get.find<FontControllerImp>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => customShareContent(controllerAfter),
              icon: Icon(
                Icons.share,
                size: ResponsiveHelper.scaledIconSize(context, 24),
              ),
            ),
            Center(
              child: Text(
                "أذكار بعد الصلاة",
                style: TextStyle(
                  color: AppColor.primaryColorGolden,
                  backgroundColor: AppColor.primaryColorBlack2,
                  fontSize: ResponsiveHelper.scaledFontSize(context, 20),
                ),
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
              controllerAfter.increamentPageController();
            },
            child: const CustomTextSliderAthkarAfterSalat()),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GetBuilder<FloatingButtonControllerImp>(
            builder: (_) {
              return GetBuilder<AthkarAfterSalatControllerImp>(builder: (_) {
                return Builder(builder: (ctx) {
                  return CustomFloatingButton(
                    herotag: 'f2',
                    onPressed: () => controllerAfter.increamentPageController(),
                    text: Text(
                      '${controllerAfter.currentPageCounter}',
                      style:
                          AppTheme.goldenTheme.textTheme.titleMedium?.copyWith(
                        fontSize: ResponsiveHelper.scaledFontSize(ctx, 21),
                      ),
                    ),
                  );
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
