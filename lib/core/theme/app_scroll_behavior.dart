import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

class AppScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
  };
}
