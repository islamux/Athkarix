import 'package:athkarix/controller/athkar_before_go_to_bed_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_before_go_to_bed_list.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/view/widget/get_pages/get_pags_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarBeforeGoToBed extends StatelessWidget {
  const CustomTextSliderAthkarBeforeGoToBed({super.key});

  @override
  Widget build(BuildContext context) {
    final AthkarBeforeGoToBedControllerImp controller =
        Get.find<AthkarBeforeGoToBedControllerImp>();

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
          // to fix auto size of height of text
          height: MediaQuery.of(context).size.height,
          child: PageView.builder(
            reverse: true,
            // when change page (swap) reset counter in floating to zero
            onPageChanged: (index) => controller.onPageChanged(index),
            controller: controller.pageControllerS,
            itemCount: athkarBeforeGoToBedList.length,
            itemBuilder: (context, i) => Column(
              children: [
                // To make text scrollable make inside container and the container inside Expanded
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      child: GetBuilder<AthkarBeforeGoToBedControllerImp>(
                          builder: (controller) {
                        // Wrap with Obx if needed, but Theme access should suffice.
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                // Use the theme style which gets font family and size from FontControllerImp
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  ...getPagesTexts(i, athkarBeforeGoToBedList)
                                ],
                              ),
                              textAlign: TextAlign.right,
                            ),
                            if (athkarBeforeGoToBedList[i].footer != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  athkarBeforeGoToBedList[i].footer!,
                                  style: AppTheme.customTextStyleFooter(),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
