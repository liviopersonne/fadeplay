import 'package:fadeplay/mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'desktop/main.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.linux) {
      return const MaterialApp(
        home: DesktopRootWidget(),
        debugShowCheckedModeBanner: false,
      );
    } else {
      return const MaterialApp(
        home: MobileRootWidget(),
        debugShowCheckedModeBanner: false,
      );
    }
  }
}
