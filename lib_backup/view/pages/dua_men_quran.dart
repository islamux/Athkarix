import 'package:athkarix/controller/duaa_men_quran_controller.dart';
import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/view/widget/custom_text_slider_dua_men_quran.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DuaMenQuran extends StatelessWidget {
  const DuaMenQuran({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DuaMenQuranControllerImp controller =
        Get.find<DuaMenQuranControllerImp>();
    final FontControllerImp fontControllerImp = Get.find<FontControllerImp>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => customShareContent(controller),
              icon: const Icon(Icons.share),
            ),
            const Center(
              child: Text(
                "أدعية القراءن",
                style: TextStyle(
                    color: AppColor.primaryColorGolden,
                    backgroundColor: AppColor.primaryColorBlack2),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.toNamed(AppRoute.home);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.amber,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (fontControllerImp.fontSize > 15.0) {
                  fontControllerImp.decreaseFontSize();
                }
              },
              icon: const Icon(
                Icons.remove,
                color: Colors.amber,
              )),
          // Font between + -
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "الخط",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                    color: AppColor.primaryColorGolden),
              ),
            ],
          ),

          IconButton(
              onPressed: () {
                if (fontControllerImp.fontSize <= 37.0) {
                  fontControllerImp.increaseFontSize();
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.amber,
              ))
        ],
      ),
      body: const SafeArea(
        child: CustomTextSliderDuaMenQuran(),
      ),
    );
  }
}
