import 'package:athkarix/controller/home_controller.dart';
import 'package:athkarix/core/data/static/imagelink/image_link.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:athkarix/function/alert_exit_app.dart';
import 'package:athkarix/view/widget/home/custom_drawer_listview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../function/share_app.dart';
import '../widget/custom_botton.dart';
import '../widget/home/search/custom_data_search.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllerImp controllerE = Get.find<HomeControllerImp>();

    return // Wrap Scaffold to change direction of widgets in pageto rtl (arabic)
        PopScope(
      // Make PopScope first widget
      canPop: false,
      onPopInvoked: (didPop) => alertExitApp(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.black,
            foregroundColor: AppColor.amber,
            title: const Center(
              child: Text(
                "أذكــــاري",
                style: TextStyle(
                  color: AppColor.primaryColorGolden,
                  fontSize: 23,
                ),
              ),
            ),
            centerTitle: true,

            //  Search on Pages
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.amber,
                ),
              ),

              // Share button
              TextButton(
                onPressed: () => shareApp(),
                child: const Text(
                  "شارك",
                  style: TextStyle(
                    color: AppColor.primaryColorGolden,
                    fontSize: 23,
                  ),
                ),
              ),
            ],
          ),
          drawer: const Directionality(
            // Change direction of text inside drawer in right side of page
            textDirection: TextDirection.rtl,
            child: Drawer(
              backgroundColor: AppColor.primaryColorGolden,
              child: CustomDrawerListView(),
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        // Link of folder images from my custom class
                        ImageLink.image5,
                      ),
                      fit: BoxFit.cover),
                ),
              ),

              // ----------- //
              // إسحب للإعلى للمزيد
              Padding(
                padding: EdgeInsets.only(
                  // make the space for any screen
                  top: MediaQuery.of(context).size.height * 0.1,
                  right: MediaQuery.of(context).size.width * 0.4,
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: AppColor.primaryColorGolden,
                      size: 36,
                    ),
                    Text(
                      "إسحب للأعلى للمزيد",
                      style: TextStyle(
                        color: AppColor.primaryColorGolden,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 160, bottom: 130),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Button
                        CustomButton(
                          customText: "أسماء الله الحسنى",
                          onPressed: () => controllerE.goToAssmaHussna(),
                          icon: const Icon(Icons.menu_book),
                        ),

                        // Button 2
                        CustomButton(
                          customText: "الإستغفار ",
                          onPressed: () => controllerE.goToEstigfar(),
                          icon: const Icon(Icons.menu_book),
                        ),

                        // Button 3
                        CustomButton(
                          customText: "التسبيح  ",
                          onPressed: (() => controllerE.goToTasbih()),
                          icon: const Icon(Icons.menu_book),
                        ),

                        // Button 4
                        CustomButton(
                          customText: "الحمد         ",
                          onPressed: () => controllerE.goToHamd(),
                          icon: const Icon(Icons.menu_book),
                        ),

                        // Button 21
                        CustomButton(
                          customText: "الصلاة على النبي    ",
                          onPressed: (() =>
                              controllerE.goToSalatAlaRasoulAllah()),
                          icon: const Icon(Icons.menu_book),
                        ),

                        CustomButton(
                          customText: "أذكار الصبـــاح   ",
                          onPressed: () => controllerE.goToAthkarSabah(),
                          icon: const Icon(Icons.menu_book),
                        ),

                        CustomButton(
                          // Button 6
                          customText: "أذكار المساء   ",
                          onPressed: () => controllerE.goToAthkarMassa(),
                          icon: const Icon(Icons.menu_book),
                        ),
                        // Button 7
                        CustomButton(
                          customText: "الأذكار بعد الصلاة المفروضة ",
                          onPressed: () => controllerE.goToAthkarAfterSalat(),
                          icon: const Icon(Icons.menu_book),
                        ),

                        // Buttom 9
                        CustomButton(
                          customText: "الدعاء من السنــة  ",
                          onPressed: () => controllerE.goToDuaMenSunnah(),
                          icon: const Icon(Icons.menu_book),
                        ),

                        // BUtton 20
                        CustomButton(
                          customText: "الدعاء من القراءن الكريم  ",
                          onPressed: (() => controllerE.goToDuaMenQuran()),
                          icon: const Icon(Icons.menu_book),
                        ),

                        // Button 8
                        CustomButton(
                          customText: " أذكار النوم   ",
                          onPressed: () =>
                              controllerE.goToAthkarBeforeGoToBed(),
                          icon: const Icon(Icons.menu_book),
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
    );
  }
}
