import 'package:flutter/foundation.dart';
import 'desktop/main.dart';
import 'mobile/main.dart';

void main(List<String> args) {
  if (defaultTargetPlatform == TargetPlatform.linux) {
    desktopMain(args);
  } else {
    mobileMain();
  }
}
