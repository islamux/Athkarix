import 'package:athkarix/controller/hamd_controller.dart';
import 'package:athkarix/core/data/model/model_list/hamd_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/view/widget/get_pages/get_pags_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderHamd extends StatelessWidget {
  const CustomTextSliderHamd({super.key});

  @override
  Widget build(BuildContext context) {
    final HamdControllerImp controllerH = Get.find<HamdControllerImp>();
    return Stack(
      children: [
        // 1 in stack
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageLink.image12,
              ),
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
            onPageChanged: (val) {
              // Check the number of pages of hamd
              controllerH.onPageChanged(val);
            },
            itemCount: hamdList.length,
            itemBuilder: (context, i) => Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      child:
                          GetBuilder<HamdControllerImp>(builder: (controllerH) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: controllerH.fontSize,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Amiri",
                                  color: Colors.black,
                                ),
                                children: [
                                  ...getPagesTexts(i, hamdList),
                                  // TextSpan(text: hamdList[i].duaText ?? ''),
                                ],
                              ),
                              textAlign: TextAlign.right,
                            ),
                            if (hamdList[i].footer != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  hamdList[i].footer!,
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
