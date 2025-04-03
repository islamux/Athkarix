import 'package:athkarix/controller/duaa_men_sunnah_controller.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/function/decrease_font.dart';
import 'package:athkarix/function/increase_font.dart';
import 'package:athkarix/view/widget/custom_text_slider_dua_men_sunnah.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/data/static/theme/app_color_constant.dart';

class DuaMenSunnah extends StatelessWidget {
  const DuaMenSunnah({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DuaMenSunnahControllerImp controller =
        Get.find<DuaMenSunnahControllerImp>();

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
                "أدعية السنة",
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
                decreaseFont(controller);
              },
              icon: const Icon(Icons.remove, color: Colors.amber)),
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
                increaseFont(controller);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.amber,
              ))
        ],
      ),
      body: const SafeArea(
        child: Column(children: [
          Expanded(
            flex: 9,
            child: CustomTextSliderDuaMenSunnah(),
          ),
        ]),
      ),
    );
  }
}
