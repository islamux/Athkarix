import 'package:flutter/foundation.dart';

increaseFont(contrller) {
  if (contrller.fontSize <= 37.0) {
    contrller.increaseFontSize();
    if (kDebugMode) {
      print("Font size From Function:${contrller.fontSize}");
    }
  }
}
