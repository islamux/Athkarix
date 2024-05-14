// Add share social media

import 'package:flutter_share/flutter_share.dart';

shareApp() {
  return FlutterShare.share(
    title: 'مشاركة عبر',
    text: 'تطبيق أذكاري',
    // todo
    linkUrl: 'سيتم عرض العنوان حال رفع التطبيق .. نشكر لكم ثقتكم',
    chooserTitle: ' مشاركة عبر',
  );
}
