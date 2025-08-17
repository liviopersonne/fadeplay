import 'package:flutter/material.dart';

void mobileMain() {
  runApp(const MobileApp());
}

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World from Mobile!'))),
      debugShowCheckedModeBanner: false,
    );
  }
}
