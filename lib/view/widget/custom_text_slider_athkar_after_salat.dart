import 'package:athkarix/controller/athkar_after_salat_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_after_salat_list.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarAfterSalat extends StatelessWidget {
  const CustomTextSliderAthkarAfterSalat({super.key});

  @override
  Widget build(BuildContext context) {
    final AthkarAfterSalatControllerImp controllerAfter =
        Get.find<AthkarAfterSalatControllerImp>();

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
            onPageChanged: (index) =>
                controllerAfter.onPageChanged(index),
            controller: controllerAfter.pageControllerS,
            itemCount: athkarAfterSalatList.length,
            itemBuilder: (context, i) => Column(
              children: [
                // To make text scrollable make inside container and the container inside Expanded
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      child: GetBuilder<AthkarAfterSalatControllerImp>(
                          builder: (controller) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              athkarAfterSalatList[i].duaText ?? '',
                              style: TextStyle(
                                fontSize: controllerAfter.fontSize,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Amiri",
                              ),
                              textAlign: TextAlign.right,
                            ),
                            if (athkarAfterSalatList[i].footer != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  athkarAfterSalatList[i].footer!,
                                  style: TextStyle(
                                    fontSize: controllerAfter.fontSize * 0.8,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Amiri",
                                  ),
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
