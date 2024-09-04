import 'package:athkarix/core/data/model/model_list/athkar_before_go_to_bed_list.dart';
import 'package:athkarix/core/data/static/theme/app_them.dart';
import 'package:flutter/material.dart';

List<TextSpan> getPagesTexts(int i) {
  TextStyle footer = AppTheme.customTextStyleFooter();
  TextStyle ayah = AppTheme.customTextStyleHadith();

  return [
    TextSpan(text: athkarBeforeGoToBedList[i].duaText),
    TextSpan(text: athkarBeforeGoToBedList[i].footer, style: footer)
  ];
}
