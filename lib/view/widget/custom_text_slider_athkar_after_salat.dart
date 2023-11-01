import 'package:athkarix/controller/athkar_after_salat_controller.dart';
import 'package:athkarix/core/data/model/athkar_after_salat_list.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderAthkarAfterSalat extends StatelessWidget {
  // here instead of extends from stelsswidget it replace with Getview and pass AthkarAfterSalatControllerImp to take controller from
  // Or By Adding final instance from class and using it to access page.

  const CustomTextSliderAthkarAfterSalat({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject athkarAfterSalatControllerImp ==> show above // here instead.....
    // Disable controller becuse of using GetView<Athka...>
    final AthkarAfterSalatControllerImp controllerAfter =
        Get.find<AthkarAfterSalatControllerImp>();

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
            //   Get.find<AthkarAfterSalatControllerImp>().resetCounter();
            // Remove instance (controllerAfter) AthkarAfterSalatController and replace it with Get.find<>().pageController
            controller: controllerAfter.pageControllerS,
            itemCount: athkarAfterSalatList.length,
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
                          GetBuilder<AthkarAfterSalatControllerImp>(
                              builder: (controller) {
                        return Text(
                          athkarAfterSalatList[i].duaText ?? '',
                          // Provide a default value (?? '') in case duaText is null
                          style: //AppTheme.goldenTheme.textTheme.bodyLarge,
                              TextStyle(
                            // Problem here is fontsize need to hotreload why?
                            // I found the solution by wrab Text with GetBuilder to refresh only the
                            // widgt not all page
                            fontSize:
                                //Get.find<AthkarAfterSalatControllerImp>().fontSize,
                                controllerAfter.fontSize,
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
