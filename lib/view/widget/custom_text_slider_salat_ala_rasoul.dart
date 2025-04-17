import 'package:athkarix/controller/salat_ala_rasoul_controller.dart';
import 'package:athkarix/core/data/model/model_list/salat_ala_rasoul_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart'; // Import AppTheme
import 'package:athkarix/view/widget/get_pages/get_pags_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderSalatAlaRasoul extends StatelessWidget {
  const CustomTextSliderSalatAlaRasoul({super.key});

  @override
  Widget build(BuildContext context) {
    final SalatAlaRasoulAllahControllerImp controllerSa =
        Get.find<SalatAlaRasoulAllahControllerImp>();
    // to enable refresh ui (slider() moving)
    return GetBuilder<SalatAlaRasoulAllahControllerImp>(
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
                controller: controllerSa.pageControllerR,
                onPageChanged: (index) =>
                    // How to pass index. ==> onPageChanged(index)
                    controllerSa.onPageChanged(index),
                itemCount: salatAlaRasoulAllahList.length,
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
                                      ...getPagesTexts(
                                          i, salatAlaRasoulAllahList)
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              if (salatAlaRasoulAllahList[i].footer != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Obx(
                                    () => Text(
                                      salatAlaRasoulAllahList[i].footer!,
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
                      value: controllerSa.currentPageIndex.toDouble(),
                      onChanged: (double value) {
                        controllerSa.goToPage(value.toInt());
                      },
                      min: 0,
                      max: salatAlaRasoulAllahList.length.toDouble() - 1,
                    ),
                  ),
                  // Display current page number
                  Text(
                    //'${controllerSa.currentPageCounter + 1} / ${salatAlaRasoulList.length}',
                    '${controllerSa.currentPageIndex.toInt()} / ${salatAlaRasoulAllahList.length}',
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
