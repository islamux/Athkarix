import 'package:athkarix/controller/duaa_men_quran_controller.dart';
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

  get controller => null;

  @override
  Widget build(BuildContext context) {
    // Inject controller
    //DuaMenQuranControllerImp controller = Get.put((DuaMenQuranControllerImp()));
    // final DuaMenQuranControllerImp controller =
    Get.find<DuaMenQuranControllerImp>();
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
              child:  Text(
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
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.decreaseFontSize();
              },
              icon: const Icon(Icons.remove)),
          // Font between + -
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "الخط",
                style: TextStyle(color: AppColor.primaryColorGolden),
              ),
            ],
          ),

          IconButton(
              onPressed: () {
                controller.increaseFontSize();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: const SafeArea(
        child: CustomTextSliderDuaMenQuran(),
      ),
    );
  }
}
