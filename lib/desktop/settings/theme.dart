import 'package:flutter/material.dart';

class MyTheme {
  MyTheme._();

  /// The padding between a title label and the separatro on the left
  static double headerLabelPadding = 3;

  /// The color of a header
  static Color headerBaseColor = Colors.amber;

  /// The color of the child header when it's being dragged
  static Color headerSecondaryColor = Colors.grey;

  /// The color of a header when it's being dragged
  static Color headerDraggingColor = Colors.deepPurple;

  /// The style of the text of the header when it's being dragged
  static TextStyle headerDraggingTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
    fontSize: 18,
  );

  /// Save theme
  static void saveTheme() {
    throw UnimplementedError("Haven't implemented saving settings yet");
  }

  /// Load theme
  static void loadTheme() {
    throw UnimplementedError("Haven't implemented loading settings yet");
  }
}
