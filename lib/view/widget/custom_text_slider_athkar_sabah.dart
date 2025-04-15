import 'package:athkarix/controller/athkar_sabah_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_sabah_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/view/widget/get_pages/get_pags_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarSabah extends StatelessWidget {
  const CustomTextSliderAthkarSabah({super.key});

  @override
  Widget build(BuildContext context) {
    final AthkarSabahControllerImp controller =
        Get.find<AthkarSabahControllerImp>();
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
            itemCount: athkarSabahList.length,
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
                          RichText(
                            text: TextSpan(
                              style: AppTheme.goldenTheme.textTheme.bodyLarge,
                              children: [...getPagesTexts(i, athkarSabahList)],
                            ),
                            textAlign: TextAlign.right,
                          ),
                          if (athkarSabahList[i].footer != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                athkarSabahList[i].footer!,
                                style: AppTheme.customTextStyleFooter(),
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
  }
}
