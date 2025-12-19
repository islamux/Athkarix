import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'binding.dart';
import 'view/pages/home.dart';

void main() {
  // splash screen
//  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // After splash screen now you could run app
  runApp(const Athkari());
  // wait 6 second showing splash screen.
  Future.delayed(const Duration(seconds: 4), () {
    FlutterNativeSplash.remove();
  });
}

class FlutterNativeSplash {
  static void preserve({required WidgetsBinding widgetsBinding}) {}

  static void remove() {}
}

class Athkari extends StatelessWidget {
  const Athkari({super.key});
  @override
  Widget build(BuildContext context) {
    // Remove splash screen after after app run

    //check if there are images in all application that decrease performance.
    //debugInvertOversizedImages = true; // i disable it after check images

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Athkari',
      theme: AppTheme.goldenTheme,
      initialBinding: MyBinding(),
      home: const Home(),
      // Routes
      getPages: routes,
    );
  }
}
