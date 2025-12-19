import 'package:athkarix/core/data/model/athkar_model.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:flutter/material.dart';

class CustomSearchResultPage extends StatelessWidget {
  final AthkarModel athkar;

  const CustomSearchResultPage({super.key, required this.athkar});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.black,
          title: const Text(
            ' نتائج البحث',
            style: TextStyle(
                color: AppColor.primaryColorGolden,
                backgroundColor: AppColor.primaryColorBlack2),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            athkar.duaText!,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
