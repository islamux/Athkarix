import 'package:athkarix/controller/duaa_men_sunnah_controller.dart';
import 'package:athkarix/core/data/model/model_list/dua_men_sunnah_list.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/view/widget/get_pages/get_pags_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderDuaMenSunnah extends StatelessWidget {
  // here instead of extends from stelsswidget it replace with Getview and pass DuaMenSunnahControllerImp to take controller from.
  // Or By Adding final instance from class and using it to access page.
  const CustomTextSliderDuaMenSunnah({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject athkarSabahControllerImp ==> show above // here instead.....
    // Disable controller becuse of using Getview<Dua...>
    final DuaMenSunnahControllerImp controllerSu =
        Get.find<DuaMenSunnahControllerImp>();
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
              // Check the number of pages of duaMenSunnah
              controllerSu.onPageChanged(val);
            },
            itemCount: duaMenSunnahList.length,
            itemBuilder: (context, i) => Column(
              children: [
                // To make text scrollable make insid contatiner and the container inside Expanded
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      // To make font change when click on button wrab Text() with GetBuilder<Page1controllerImp>(build: (controller) return Text())
                      child: GetBuilder<DuaMenSunnahControllerImp>(
                          builder: (controllerSu) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: "Amiri",
                                  fontSize: controllerSu.fontSize,
                                  color: Colors.black,
                                ),
                                children: [
                                  ...getPagesTexts(i, duaMenSunnahList)
                                ],
                              ),
                              textAlign: TextAlign.right,
                            ),
                            if (duaMenSunnahList[i].footer != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  duaMenSunnahList[i].footer!,
                                  style: TextStyle(
                                    fontSize: controllerSu.fontSize * 0.8,
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
