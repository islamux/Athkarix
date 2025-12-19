// controller pass as a parameter to controll every page controller .
import 'package:share_plus/share_plus.dart';

String customShareContent(var controller) {
  // Get current page index
  final index = controller.currentPageIndex;

  // Get the text to share from controller
  var shareText = controller.getShareText(index);

  // share the text
  shareText = Share.share(shareText) as String;

  return shareText;
}
