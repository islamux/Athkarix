import 'dart:convert';
import 'package:athkarix/controller/comprehensive_adhkar_controller.dart';
import 'package:athkarix/controller/floating_action_button_controller.dart';
import 'package:athkarix/controller/font_controller.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/function/custom_share_content.dart';
import 'package:athkarix/view/widget/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ComprehensiveAdhkar extends StatelessWidget {
  const ComprehensiveAdhkar({super.key});

  @override
  Widget build(BuildContext context) {
    final ComprehensiveAdhkarControllerImp controller =
        Get.find<ComprehensiveAdhkarControllerImp>();
    Get.put(FloatingButtonControllerImp());
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
                "الأذكار الشاملة",
                style: TextStyle(
                  color: AppColor.primaryColorGolden,
                  backgroundColor: AppColor.primaryColorBlack2,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            controller.resetCounter();
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
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "الخط",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  color: AppColor.primaryColorGolden,
                ),
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
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Feedback.forTap(context);
            controller.increamentPageController();
          },
          child: FutureBuilder<List<dynamic>>(
            future: controller.loadAdhkarData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColorGolden,
                  ),
                );
              }

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
                    height: MediaQuery.of(context).size.height,
                    child: PageView.builder(
                      reverse: true,
                      onPageChanged: (index) => controller.onPageChanged(index),
                      controller: controller.pageController,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) => Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 60,
                                left: 32,
                                right: 32,
                                bottom: 60,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () => RichText(
                                        text: TextSpan(
                                          style: AppTheme.goldenTheme.textTheme.bodyLarge,
                                          children: [
                                            TextSpan(
                                              text: snapshot.data![i]['text'] ?? '',
                                              style: TextStyle(
                                                fontSize: fontControllerImp.fontSize.value,
                                                color: AppColor.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    if (snapshot.data![i]['description'] != null &&
                                        snapshot.data![i]['description'].isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16.0),
                                        child: Obx(
                                          () => Text(
                                            snapshot.data![i]['description'],
                                            style: AppTheme.customTextStyleFooter(),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    if (snapshot.data![i]['reference'] != null &&
                                        snapshot.data![i]['reference'].isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "المصدر: ${snapshot.data![i]['reference']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.primaryColorGolden.withOpacity(0.8),
                                            fontStyle: FontStyle.italic,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryColorGolden.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "عدد المرات: ${snapshot.data![i]['count'] ?? 1}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColor.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
            },
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GetBuilder<FloatingButtonControllerImp>(
            builder: (context) {
              return GetBuilder<ComprehensiveAdhkarControllerImp>(
                builder: (context) {
                  return CustomFloatingButton(
                    herotag: 'comprehensive',
                    onPressed: () => controller.increamentPageController(),
                    text: Text(
                      '${controller.currentPageCounter}',
                      style: AppTheme.goldenTheme.textTheme.titleMedium,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
