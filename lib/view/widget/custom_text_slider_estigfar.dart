import 'package:athkarix/controller/estigfar_controller.dart';
import 'package:athkarix/core/data/model/model_list/estigfar_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// testing to use Getviwe to call controller
class CustomTextSliderEstigfar extends GetView<EstigfarControllerImp> {
  const CustomTextSliderEstigfar({super.key});

  @override
  Widget build(BuildContext context) {
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
          // to fix auto size of hight of text
          height: MediaQuery.of(context).size.height,
          child: PageView.builder(
            reverse: true,
            onPageChanged: (val) {
              // Check the number of pages of estigfar
              controller.onPageChanged(val);
            },
            itemCount: estigfarList.length,
            itemBuilder: (context, i) => Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      child: GetBuilder<EstigfarControllerImp>(
                        builder: (controllerE) {
                          return Text(
                            estigfarList[i].duaText ?? '',
                            style: TextStyle(
                              fontSize:
                                  //Get.find<EstigfarControllerImp>().fontSize,
                                  controllerE.fontSize,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Amiri",
                            ),
                            textAlign: TextAlign.right,
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
