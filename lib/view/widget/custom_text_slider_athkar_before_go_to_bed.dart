import 'package:athkarix/controller/athkar_before_go_to_bed_controller.dart';
import 'package:athkarix/core/data/model/model_list/athkar_before_go_to_bed_list.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/view/widget/get_pages/get_pags_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarBeforeGoToBed extends StatelessWidget {
  // here instead of extends from stelsswidget it replace with Getview and pass AthkarBeforeGoToBedControllerImp to take controller from
  // Or By Adding final instance from class and using it to access page.

  const CustomTextSliderAthkarBeforeGoToBed({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject athkarBeforeGoToBedControllerImp ==> show above // here instead.....
    // Disable controller becuse of using GetView<Athka...>
    final AthkarBeforeGoToBedControllerImp controllerAfter =
        Get.find<AthkarBeforeGoToBedControllerImp>();

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
          // to fix auto size of hight of text
          height: MediaQuery.of(context).size.height,
// PageView builder
          child: PageView.builder(
            reverse: true,
            // when change page (swap ) rest counter in floating to zero
            onPageChanged: (index) =>
                // How to pass index. ==> onPageChanged(index)
                controllerAfter.onPageChanged(index),
            //   Get.find<AthkarBeforeGoToBedControllerImp>().resetCounter();
            // Remove instance (controllerAfter) AthkarBeforeGoToBedController and replace it with Get.find<>().pageController
            controller: controllerAfter.pageControllerS,
            itemCount: athkarBeforeGoToBedList.length,
            itemBuilder: (context, i) => Column(
              children: [
                // To make text scrollable make insid contatiner and the container inside Expanded
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      child:
                          // To make font change when click on button wrab Text() with GetBuilder<Page1controllerImp>(build: (controller) return Text())
                          GetBuilder<AthkarBeforeGoToBedControllerImp>(
                              builder: (controller) {
                        return RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: "AmiriQ",
                              fontSize: controllerAfter.fontSize,
                              color: Colors.black,
                            ),
                            children: [...getPagesTexts(i)],
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
