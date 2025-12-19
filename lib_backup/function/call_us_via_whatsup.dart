import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void callUsViaWhatsUp() async {
  String counterCode = 'YE';
  String whatsUpNumber = '772699924';
  String whatsUpOnGooglePlay =
      'https://play.google.com/store/apps/details?id=com.whatsapp';

  try {
    await launchUrl(
        Uri.parse('whatsapp://send?phone=$counterCode$whatsUpNumber'));
  } on PlatformException catch (e) {
    if (e.code == 'ACTIVITY_NOT_FOUND') {
      // The WhatsApp app is not installed on the device.
      // Open the Google Play Store app to install WhatsApp.
      await launchUrl(Uri.parse(whatsUpOnGooglePlay));
    }
  }
}
