import 'package:athkarix/controller/home_controller.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/core/utils/responsive_helper.dart';
import 'package:athkarix/function/alert_exit_app.dart';
import 'package:athkarix/view/widget/home/custom_drawer_listview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/custom_button.dart';
import '../widget/home/search/custom_data_search.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllerImp controllerE = Get.find<HomeControllerImp>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (result, didPop) => alertExitApp(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.black,
            foregroundColor: AppColor.amber,
            title: Center(
              child: Text(
                "أذكــــاري",
                style: TextStyle(
                  color: AppColor.primaryColorGolden,
                  fontSize: ResponsiveHelper.scaledFontSize(context, 23),
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.amber,
                  size: ResponsiveHelper.scaledIconSize(context, 24),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "شارك",
                  style: TextStyle(
                    color: AppColor.primaryColorGolden,
                    fontSize: ResponsiveHelper.scaledFontSize(context, 23),
                  ),
                ),
              ),
            ],
          ),
          drawer: const Directionality(
            textDirection: TextDirection.rtl,
            child: Drawer(
              backgroundColor: AppColor.primaryColorGolden,
              child: CustomDrawerListView(),
            ),
          ),
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageLink.image5),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: ResponsiveHelper.scaledFontSize(context, 20)),
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: AppColor.primaryColorGolden,
                            size: ResponsiveHelper.scaledIconSize(context, 36),
                          ),
                          Text(
                            "إسحب للأعلى للمزيد",
                            style: TextStyle(
                              color: AppColor.primaryColorGolden,
                              fontSize:
                                  ResponsiveHelper.scaledFontSize(context, 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.scaledFontSize(context, 400),
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              ResponsiveHelper.scaledFontSize(context, 20),
                          vertical:
                              ResponsiveHelper.scaledFontSize(context, 10),
                        ),
                        children: [
                          Center(
                            child: CustomButton(
                              customText: "أسماء الله الحسنى",
                              onPressed: () => controllerE.goToAssmaHussna(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveHelper.scaledFontSize(context, 15)),
                          Center(
                            child: CustomButton(
                              customText: "الإستغفار ",
                              onPressed: () => controllerE.goToEstigfar(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveHelper.scaledFontSize(context, 15)),
                          Center(
                            child: CustomButton(
                              customText: "التسبيح  ",
                              onPressed: () => controllerE.goToTasbih(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveHelper.scaledFontSize(context, 15)),
                          Center(
                            child: CustomButton(
                              customText: "الحمد         ",
                              onPressed: () => controllerE.goToHamd(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveHelper.scaledFontSize(context, 15)),
                          Center(
                            child: CustomButton(
                              customText: "الصلاة على النبي    ",
                              onPressed: () =>
                                  controllerE.goToSalatAlaRasoulAllah(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveHelper.scaledFontSize(context, 15)),
                          Center(
                            child: CustomButton(
                              customText: "أذكار الصبـــاح   ",
                              onPressed: () => controllerE.goToAthkarSabah(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveHelper.scaledFontSize(context, 15)),
                          Center(
                            child: CustomButton(
                              customText: "أذكار المساء   ",
                              onPressed: () => controllerE.goToAthkarMassa(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveHelper.scaledFontSize(context, 15)),
                          Center(
                            child: CustomButton(
                              customText: "الأذكار بعد الصلاة المفروضة ",
                              onPressed: () =>
                                  controllerE.goToAthkarAfterSalat(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveHelper.scaledFontSize(context, 15)),
                          Center(
                            child: CustomButton(
                              customText: "الدعاء من السنــة  ",
                              onPressed: () => controllerE.goToDuaMenSunnah(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveHelper.scaledFontSize(context, 15)),
                          Center(
                            child: CustomButton(
                              customText: "الدعاء من القراءن الكريم  ",
                              onPressed: () => controllerE.goToDuaMenQuran(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveHelper.scaledFontSize(context, 15)),
                          Center(
                            child: CustomButton(
                              customText: " أذكار النوم   ",
                              onPressed: () =>
                                  controllerE.goToAthkarBeforeGoToBed(),
                              icon: const Icon(Icons.menu_book),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
