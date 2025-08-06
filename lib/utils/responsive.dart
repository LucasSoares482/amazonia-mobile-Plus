import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double fontSize(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet ?? mobile * 1.2;
    return desktop ?? mobile * 1.5;
  }

  static EdgeInsets padding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16);
    if (isTablet(context)) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }

  static int gridCount(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  static double maxWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 600;
    return 800;
  }
}