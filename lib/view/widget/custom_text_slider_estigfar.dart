import 'package:athkarix/controller/estigfar_controller.dart';
import 'package:athkarix/core/data/model/model_list/estigfar_list_model.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/view/widget/get_pages/get_pags_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// testing to use GetView to call controller
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
          // to fix auto size of height of text
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
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: "Amiri",
                                    fontSize: controllerE.fontSize,
                                    color: Colors.black,
                                  ),
                                  children: [...getPagesTexts(i, estigfarList)],
                                ),
                                textAlign: TextAlign.right,
                              ),
                              if (estigfarList[i].footer != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    estigfarList[i].footer!,
                                    style: AppTheme.customTextStyleFooter(),
                                  ),
                                ),
                            ],
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
