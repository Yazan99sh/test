import 'package:yes_order/module_profile/ui/screen/activity_screen/activity_screen.dart';
import 'package:flutter/material.dart';

abstract class ActivityState {
  final ActivityScreenState screen;
  ActivityState(this.screen);

  Widget getUI(BuildContext context);
}