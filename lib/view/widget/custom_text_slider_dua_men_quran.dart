import 'package:athkarix/controller/duaa_men_quran_controller.dart';
import 'package:athkarix/core/data/model/model_list/dua_men_quran_list.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// in these classe i test using another way to call controller using GetView
class CustomTextSliderDuaMenQuran extends StatelessWidget {
  const CustomTextSliderDuaMenQuran({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject athkarSabahControllerImp ==> show above // here instead.....
    // Disble controller becuse of using GetView<Dua..>
    final DuaMenQuranControllerImp controllerQ =
        Get.find<DuaMenQuranControllerImp>();
    return Stack(
      // add backgruond image
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
              controllerQ.onPageChanged(val);
            },
            itemCount: duaMenQuranList.length,
            itemBuilder: (context, i) => Column(
              children: [
                // To make text scrollable make insid contatiner and the container inside Expanded
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 60, left: 32, right: 32, bottom: 60),
                    child: SingleChildScrollView(
                      // To make font change when click on button wrab Text() with GetBuilder<Page1controllerImp>(build: (controller) return Text())
                      // Wrap Text with column to add share icon , then wrap column with GestureDetector()to make text page clickable.
                      child: GetBuilder<DuaMenQuranControllerImp>(
                        builder: (controllerQ) => Text(
                          duaMenQuranList[i].duaText ??
                              '', // Provide a default value (?? '') in case duaText is null
                          style: TextStyle(
                            fontSize:
                                //Get.find<DuaMenQuranControllerImp>().fontsize,
                                controllerQ.fontsize,
                            fontFamily: "Amiri",
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
