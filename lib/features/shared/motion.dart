import 'package:flutter/animation.dart';

abstract final class MotionDurations {
  static const onboardingEnter = Duration(milliseconds: 520);
  static const stepTransition = Duration(milliseconds: 360);
  static const progress = Duration(milliseconds: 700);
  static const otpShake = Duration(milliseconds: 420);
  static const cardEntrance = Duration(milliseconds: 480);
  static const tabSwitch = Duration(milliseconds: 300);
}

abstract final class MotionCurves {
  static const entrance = Curves.easeOutCubic;
  static const sharedAxis = Curves.easeInOutCubic;
  static const press = Curves.easeOut;
}
