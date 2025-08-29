import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyTheme {
  MyTheme._();

  /// The padding between a title label and the separatro on the left
  static double headerLabelPadding = 3;

  /// The color of a header
  static Color headerBaseColor = Colors.amber;

  /// The color of the child header when it's being dragged
  static Color headerSecondaryColor = Colors.grey;

  /// The color of a header when it's being dragged
  static Color headerDraggingColor = Colors.deepPurple.withAlpha(100);

  /// The color of a `DragTarget` when it's ready to accept
  static Color dragTargetColor = Colors.white;

  /// The default padding size
  static double paddingSmall = 3.dp;
  static double paddingBig = 8.dp;

  /// The text styles
  static TextStyle textStyleNormal = TextStyle(
    color: Colors.white,
    fontSize: 12.sp,
  );
  static TextStyle textStyleInactive = TextStyle(
    color: Colors.grey,
    fontSize: 12.sp,
  );
  static TextStyle textStyleTitle = TextStyle(
    color: Colors.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
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
