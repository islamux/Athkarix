import 'package:athkarix/controller/athkar_sabah_controller.dart';
import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarSabah extends StatelessWidget {
  const CustomTextSliderAthkarSabah({super.key});

  @override
  Widget build(BuildContext context) {
    final AthkarSabahControllerImp controller =
        Get.find<AthkarSabahControllerImp>();
    final FontControllerImp fontController = Get.find<FontControllerImp>();
    return GetBuilder<AthkarSabahControllerImp>(
      builder: (_) {
        // Show loading indicator while data is being loaded
        if (controller.adhkarSabahList == null || controller.adhkarSabahList!.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
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
              child: PageView.builder(
                reverse: true,
                onPageChanged: (index) => controller.onPageChanged(index),
                controller: controller.pageControllerS,
                itemCount: controller.adhkarSabahList!.length,
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
                                () => Text(
                                  controller.getAthkarText(i),
                                  style: TextStyle(
                                    fontSize: fontController.fontSize.value,
                                    fontFamily: fontController.selectFont.value,
                                    fontWeight: FontWeight.normal,
                                    color: AppColor.black,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              if (controller.getAthkarDescription(i).isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    controller.getAthkarDescription(i),
                                    style: AppTheme.customTextStyleFooter(),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              if (controller.getAthkarReference(i).isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    controller.getAthkarReference(i),
                                    style: AppTheme.customTextStyleFooter()?.copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
