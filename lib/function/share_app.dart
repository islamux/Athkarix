// Add share social media

import 'package:flutter_share/flutter_share.dart';

shareApp() {
  print("Add linkUrl fter push app to GooglePlay store !");
  return FlutterShare.share(
    title: 'مشاركة عبر',
    text: 'تطبيق أذكاري',
    linkUrl: 'سيتم عرض العنوان حال رفع التطبيق .. نشكر لكم ثقتكم',
    chooserTitle: ' مشاركة عبر',
  );
}
