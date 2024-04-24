import 'package:flutter/foundation.dart';

// increaseFont(controllerCurrentFont, controllerIncrease) {
//   if (controllerCurrentFont > 21.0) {
//     controllerIncrease;
//     if (kDebugMode) {
//       print("Font size :$controllerCurrentFont");
//     }
//   }
// }

increaseFont(contrller) {
  if (contrller.fontSize <= 37.0) {
    contrller.increaseFontSize();
    if (kDebugMode) {
      print("Font size :${contrller.fontSize}");
    }
  }
}
