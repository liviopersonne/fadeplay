import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SubWindowApp extends StatelessWidget {
  final int windowId;
  final Map<String, dynamic> args;

  const SubWindowApp({required this.windowId, required this.args, super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, _, _) => MaterialApp(
        home: Scaffold(body: Center(child: Text("I am window #$windowId"))),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
