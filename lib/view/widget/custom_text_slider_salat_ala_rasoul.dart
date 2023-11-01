import 'package:athkarix/controller/salat_ala_rasoul_controller.dart';
import 'package:athkarix/core/data/model/salat_ala_rasoul_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
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
          // to fix auto size of hight of text
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
                // To make text scrollable make insid contatiner and the container inside Expanded
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      child: GetBuilder<SalatAlaRasoulAllahControllerImp>(
                        builder: (controllerR) => Text(
                          salatAlaRasoulAllahList[i].duaText ?? '',
                          style: TextStyle(
                              fontSize:
                                  //Get.find<SalatAlaRasoulAllahControllerImp>()
                                  controllerR.fontSize,
                              fontFamily: "Amiri",
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.right,
                        ),
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
