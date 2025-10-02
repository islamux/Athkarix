import 'package:athkarix/controller/duaa_men_quran_controller.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart'; // Import AppTheme
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderDuaMenQuran extends StatelessWidget {
  const CustomTextSliderDuaMenQuran({super.key});

  @override
  Widget build(BuildContext context) {
    final DuaMenQuranControllerImp controllerD =
        Get.find<DuaMenQuranControllerImp>();
    // to enable refresh ui (slider() moving)
    return GetBuilder<DuaMenQuranControllerImp>(
      builder: (controller) {
        if (controller.duaMenQuranList == null || controller.duaMenQuranList!.isEmpty) {
          return const Center(child: CircularProgressIndicator());
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
              // to fix auto size of hight of text
              height: MediaQuery.of(context).size.height,
              child: PageView.builder(
                reverse: true,
                // to enable move through pages slider() using pageController
                controller: controllerD.pageControllerQuran,
                onPageChanged: (index) =>
                    // How to pass index. ==> onPageChanged(index)
                    controllerD.onPageChanged(index),
                itemCount: controller.duaMenQuranList!.length,
                itemBuilder: (context, i) => Column(
                  children: [
                    // To make text scrollable make insid contatiner and the container inside Expanded
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
                                    style: AppTheme
                                        .goldenTheme.textTheme.bodyLarge,
                                    children: [
                                      TextSpan(text: controller.duaMenQuranList![i]['text'])
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              if (controller.duaMenQuranList![i]['description'] != null && controller.duaMenQuranList![i]['description'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Obx(
                                    () => Text(
                                      controller.duaMenQuranList![i]['description']!,
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
              ),
            ),

            // slider widget
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Slider(
                      activeColor: AppColor.black,
                      inactiveColor: AppColor.grey,
                      value: controllerD.currentPageIndex.toDouble(),
                      onChanged: (double value) {
                        controllerD.goToPage(value.toInt());
                      },
                      min: 0,
                      max: controller.duaMenQuranList!.length.toDouble() - 1,
                    ),
                  ),
                  // Display current page number
                  Text(
                    '${controllerD.currentPageIndex.toInt() + 1} / ${controller.duaMenQuranList!.length}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
