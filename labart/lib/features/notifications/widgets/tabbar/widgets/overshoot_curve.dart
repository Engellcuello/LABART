import 'package:flutter/material.dart';

class OvershootCurve extends Curve {
  @override
  double transform(double t) {
    if (t < 0.8) {
      final progress = Curves.easeOut.transform(t / 0.8);
      return progress * 1.05;
    } else {
      final retractT = (t - 0.8) / 0.2;
      final ease = retractT < 0.5
          ? 2 * retractT * retractT
          : -1 + (4 - 2 * retractT) * retractT;
      return 1.05 - ease * 0.05;
    }
  }
}