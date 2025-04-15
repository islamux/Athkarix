import 'package:athkarix/controller/athkar_after_salat_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_after_salat_list.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart'; // Import AppTheme
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarAfterSalat extends StatelessWidget {
  const CustomTextSliderAthkarAfterSalat({super.key});

  @override
  Widget build(BuildContext context) {
    final AthkarAfterSalatControllerImp controllerAfter =
        Get.find<AthkarAfterSalatControllerImp>();
    // to enable refresh ui (slider() moving)
    return GetBuilder<AthkarAfterSalatControllerImp>(
      builder: (_) {
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
                controller: controllerAfter.pageControllerS,
                onPageChanged: (index) =>
                    // How to pass index. ==> onPageChanged(index)
                    controllerAfter.onPageChanged(index),
                itemCount: athkarAfterSalatList.length,
                itemBuilder: (context, i) => Column(
                  children: [
                    // To make text scrollable make insid contatiner and the container inside Expanded
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 60, left: 32, right: 32, bottom: 60),
                        child: SingleChildScrollView(
                          child: Text(
                            athkarAfterSalatList[i].duaText ?? '',
                            style: AppTheme.goldenTheme.textTheme
                                .bodyLarge, // Use theme style
                            textAlign: TextAlign.right,
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
                      value: controllerAfter.currentPageIndex.toDouble(),
                      onChanged: (double value) {
                        controllerAfter.goToPage(value.toInt());
                      },
                      min: 0,
                      max: athkarAfterSalatList.length.toDouble() - 1,
                    ),
                  ),
                  // Display current page number
                  Text(
                    //'${controllerAfter.currentPageCounter + 1} / ${afterSalatList.length}',
                    '${controllerAfter.currentPageIndex.toInt()} / ${athkarAfterSalatList.length}',
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
