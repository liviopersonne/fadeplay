import 'package:flutter/foundation.dart';
import 'desktop/main.dart';
import 'mobile/main.dart';

void main() {
  if (defaultTargetPlatform == TargetPlatform.linux) {
    desktopMain();
  } else {
    mobileMain();
  }
}
