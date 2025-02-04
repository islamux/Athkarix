import 'package:athkarix/controller/salat_ala_rasoul_controller.dart';
import 'package:athkarix/core/data/model/model_list/salat_ala_rasoul_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/view/widget/get_pages/get_pags_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderSalatAlaRasoulAllah
    extends GetView<SalatAlaRasoulAllahControllerImp> {
  const CustomTextSliderSalatAlaRasoulAllah({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject athkarSabahControllerImp ==> show above // here instead.....
    return Stack(
      // add background
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
            onPageChanged: (val) {
              // Check the number of pages of athkarSabah
              controller.onPageChanged(val);
            },
            itemCount: salatAlaRasoulAllahList.length,
            itemBuilder: (context, i) => Column(
              children: [
                // To make text scrollable make inside container and the container inside Expanded
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      child: GetBuilder<SalatAlaRasoulAllahControllerImp>(
                        builder: (controllerR) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: "AmiriQ",
                                    fontSize: controllerR.fontSize,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    ...getPagesTexts(i, salatAlaRasoulAllahList)
                                  ],
                                ),
                                textAlign: TextAlign.right,
                              ),
                              if (salatAlaRasoulAllahList[i].footer != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    salatAlaRasoulAllahList[i].footer!,
                                    style: TextStyle(
                                      fontSize: controllerR.fontSize * 0.8,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Amiri",
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                            ],
                          );
                        },
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
