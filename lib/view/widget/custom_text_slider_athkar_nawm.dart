import 'package:athkarix/controller/athkar_nawm_controller.dart';
import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarNawm extends StatelessWidget {
  const CustomTextSliderAthkarNawm({super.key});

  @override
  Widget build(BuildContext context) {
    final FontControllerImp fontController = Get.find<FontControllerImp>();
    return Stack(
      children: [
        // 1 in stack
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageLink.image12),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // 2 in stack
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GetBuilder<AthkarNawmControllerImp>(
            builder: (controller) {
              if (controller.dataList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return PageView.builder(
                reverse: true,
                onPageChanged: (index) => controller.onPageChanged(index),
                controller: controller.pageController,
                itemCount: controller.dataList.length,
                itemBuilder: (context, i) => Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 60, left: 32, right: 32, bottom: 60),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => RichText(
                                  text: TextSpan(
                                    style: AppTheme.goldenTheme.textTheme.bodyLarge,
                                    children: [
                                      TextSpan(
                                        text: controller.dataList[i]['text'] ?? '',
                                        style: TextStyle(
                                          fontSize: fontController.fontSize.value,
                                          color: AppColor.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              if (controller.dataList[i]['description'] != null &&
                                  controller.dataList[i]['description'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Obx(
                                    () => Text(
                                      controller.dataList[i]['description'],
                                      style: AppTheme.customTextStyleFooter(),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
