import 'package:athkarix/controller/athkar_massa_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_massa_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarMasaa extends StatelessWidget {
  const CustomTextSliderAthkarMasaa({super.key});

  @override
  Widget build(BuildContext context) {
    final AthkarMassaControllerImp controllerM =
        Get.find<AthkarMassaControllerImp>();

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
            onPageChanged: (index) => controllerM.onPageChanged(index),
            controller: controllerM.pageControllerM,
            itemCount: athkarMassaList.length,
            itemBuilder: (context, i) => Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      child: GetBuilder<AthkarMassaControllerImp>(
                          builder: (controllerM) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              athkarMassaList[i].duaText ?? '',
                              style: TextStyle(
                                fontSize: controllerM.fontSize,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Amiri",
                              ),
                              textAlign: TextAlign.right,
                            ),
                            if (athkarMassaList[i].footer != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  athkarMassaList[i].footer!,
                                  style: TextStyle(
                                    fontSize: controllerM.fontSize * 0.8,
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
