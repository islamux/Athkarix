import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double _tabletBreakpoint = 600.0;
  static const double _tabletScaleFactor = 1.5;

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= _tabletBreakpoint;
  }

  static double scaledFontSize(BuildContext context, double baseFontSize) {
    return isTablet(context) ? baseFontSize * _tabletScaleFactor : baseFontSize;
  }

  static double scaledIconSize(BuildContext context, double baseIconSize) {
    return isTablet(context) ? baseIconSize * _tabletScaleFactor : baseIconSize;
  }
}
