import 'package:athkarix/controller/tasbih_controller.dart';
import 'package:athkarix/core/data/model/model_list/tasbih_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/view/widget/get_pages/get_pags_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextSliderTasbih extends StatelessWidget {
  const CustomTextSliderTasbih({super.key});

  @override
  Widget build(BuildContext context) {
    //You can remove the line EstigfarControllerImp controller = Get.put(EstigfarControllerImp()); from the build() method since you already extended GetView<EstigfarControllerImp>, which allows you to access the controller instance using controller directly without the need to create a new instance.
    // Disable controller becuse of using GetView<Tas..>
    final TasbihControllerImp controllerT = Get.find<TasbihControllerImp>();
    return Stack(
      // to add background
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
              // Check the number of pages of tasbih
              controllerT.onPageChanged(val);
            },
            itemCount: tasbihList.length,
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
                          // Wrap Text to column to add share icon , then wrap column with GestureDetector to make page text clickable.
                          GetBuilder<TasbihControllerImp>(
                              builder: (controllerT) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: "Amiri",
                                  fontSize: controllerT.fontSize,
                                  color: Colors.black,
                                ),
                                children: [...getPagesTexts(i, tasbihList)],
                              ),
                              textAlign: TextAlign.right,
                            ),
                            if (tasbihList[i].footer != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  tasbihList[i].footer!,
                                  style: AppTheme.customTextStyleFooter(),
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
