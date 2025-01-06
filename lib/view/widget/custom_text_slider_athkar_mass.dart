import 'package:athkarix/controller/athkar_massa_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_massa_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarMassa extends StatelessWidget {
  const CustomTextSliderAthkarMassa({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject athkarSabahControllerImp ==> show above // here instead.....
    // Disable controller bectuse of using GetView<Athk..>
    //AthkarMassaControllerImp controllerM = Get.put(AthkarMassaControllerImp());
    final AthkarMassaControllerImp controllerM =
        Get.find<AthkarMassaControllerImp>();
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
            // Change the direction of swaping
            reverse: true,
            // to reset counter to zero when swap page in pageview builder
            onPageChanged: (index) =>
                // How to pass index. ==> onPageChanged(index)
                controllerM.onPageChanged(index),
            // Remove instance (controllerS) AthkarSabahController and replace it with Get.find<>().pageController
            controller: controllerM.pageControllerM,
            itemCount: athkarMassaList.length,
            itemBuilder: (context, i) => Column(
              children: [
                // To make text scrollable make insid contatiner and the container inside Expanded
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      child: GetBuilder<AthkarMassaControllerImp>(
                          builder: (controller) {
                        return Text(
                          athkarMassaList[i].duaText ?? '',
                          // Provide a default value (?? '') in case duaText is null
                          style: //AppTheme.goldenTheme.textTheme.bodyLarge,
                              TextStyle(
                            fontSize: controllerM.fontSize,
                            fontFamily: "Amiri",
                            fontWeight: FontWeight.w300,
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
