import 'package:athkarix/controller/hamd_controller.dart';
import 'package:athkarix/core/data/model/hamd_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
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
          // to fix auto size of hight of text
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
                        return Text(
                          hamdList[i].duaText ?? '',
                          style: TextStyle(
                            fontSize: //Get.find<HamdControllerImp>().fontSize,
                                controllerH.fontSize,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Amiri",
                          ),
                          textAlign: TextAlign.right,
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
