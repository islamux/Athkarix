import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:athkarix/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:athkarix/function/call_us_via_whatsup.dart';

class CustomDrawerListView extends StatelessWidget {
  const CustomDrawerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.call_outlined),
          title: Text(
            'تواصل معنا',
            style: AppTheme.goldenTheme.textTheme.titleMedium?.copyWith(
              fontSize: ResponsiveHelper.scaledFontSize(context, 21),
            ),
          ),
          onTap: () => callUsViaWhatsUp(),
        ),
        ListTile(
          leading: const Icon(Icons.android_outlined),
          title: Text(
            'شارك التطبيق عبر وسائل التواصل',
            style: AppTheme.goldenTheme.textTheme.titleMedium?.copyWith(
              fontSize: ResponsiveHelper.scaledFontSize(context, 21),
            ),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
