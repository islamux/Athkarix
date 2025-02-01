import 'package:athkarix/controller/athkar_sabah_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_sabah_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarSabah extends StatelessWidget {
  const CustomTextSliderAthkarSabah({super.key});

  @override
  Widget build(BuildContext context) {
    final AthkarSabahControllerImp controllerS =
        Get.find<AthkarSabahControllerImp>();

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageLink.image12),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView.builder(
            reverse: true,
            onPageChanged: (index) => controllerS.onPageChanged(index),
            controller: controllerS.pageControllerS,
            itemCount: athkarSabahList.length,
            itemBuilder: (context, i) => Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      child: GetBuilder<AthkarSabahControllerImp>(
                          builder: (controllerS) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              athkarSabahList[i].duaText ?? '',
                              style: TextStyle(
                                fontSize: controllerS.fontSize,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Amiri",
                              ),
                              textAlign: TextAlign.right,
                            ),
                            if (athkarSabahList[i].footer != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  athkarSabahList[i].footer!,
                                  style: TextStyle(
                                    fontSize: controllerS.fontSize * 0.8,
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
