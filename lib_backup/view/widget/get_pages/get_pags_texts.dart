import 'package:athkarix/core/data/model/athkar_model.dart';
import 'package:flutter/material.dart';

List<TextSpan> getPagesTexts(int pageIndex, List<AthkarModel> athkarList) {
  return [
    TextSpan(text: athkarList[pageIndex].duaText),
  ];
}
