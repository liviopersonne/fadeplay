import 'package:flutter/material.dart';

class MyTheme {
  MyTheme._();

  /// The color of a header
  static Color headerBaseColor = Colors.amber;

  /// The color of the child header when it's being dragged
  static Color headerSecondaryColor = Colors.grey;

  /// The color of a header when it's being dragged
  static Color headerDraggingColor = Colors.deepPurple.withAlpha(100);

  /// The color of a `DragTarget` when it's ready to accept
  static Color dragTargetColor = Colors.white;

  /// The text styles
  static TextStyle textStyleNormal = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );
  static TextStyle textStyleInactive = TextStyle(
    color: Colors.grey,
    fontSize: 14,
  );
  static TextStyle textStyleTitle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  /// Background colors
  static Color colorBackgroundUltraDark = Colors.grey[800]!;
  static Color colorBackgroundVeryDark = Color.fromARGB(255, 82, 82, 82);
  static Color colorBackgroundDark = Colors.grey[700]!;
  static Color colorBackgroundLight = Colors.grey[600]!;
  static Color colorBackgroundVeryLight = Colors.grey[500]!;

  /// Accent color
  // static Color colorAccentHigh = Colors.blueAccent;
  // static Color colorAccentLow = Colors.blue[400]!;
  static Color colorAccentHigh = Colors.pink;
  static Color colorAccentLow = Colors.teal;

  /// Padding values
  static double paddingTiny = 3;
  static double paddingSmall = 9;
  static double paddingMedium = 20;
  static double paddingBig = 33;

  /// Save theme
  static void saveTheme() {
    throw UnimplementedError("Haven't implemented saving settings yet");
  }

  /// Load theme
  static void loadTheme() {
    throw UnimplementedError("Haven't implemented loading settings yet");
  }
}
