import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/general/hoverable.dart';
import 'package:flutter/material.dart';

final logger = Logging("ColumnElem");

class ColumnElem<T extends Object> extends StatelessWidget {
  const ColumnElem({
    super.key,
    required this.child,
    required this.inactiveTextStyle,
    TextStyle? activeTextStyle,
    required this.inactiveColor,
    Color? activeColor,
    this.hoverable = false,
    this.hoveringCursor = MouseCursor.defer,
    this.clickable = false,
    this.onTap,
    this.draggable = false,
    this.draggableText,
    this.draggableData,
  }) : activeTextStyle = activeTextStyle ?? inactiveTextStyle,
       activeColor = activeColor ?? inactiveColor;

  final Widget child;
  final TextStyle inactiveTextStyle;
  final TextStyle activeTextStyle;
  final Color inactiveColor;
  final Color activeColor;
  final bool hoverable;
  final MouseCursor hoveringCursor;
  final bool clickable;
  final void Function()? onTap;
  final bool draggable;
  final String? draggableText;
  final T? draggableData;

  static double getHeight(TextStyle textStyle) {
    logger.check(
      textStyle.fontSize != null,
      message: "The text style passed needs to have a defined fontSize",
      raiseError: true,
    );
    return textStyle.fontSize! * 1.5;
  }

  /// The height of the element
  double _getHeight() => inactiveTextStyle.fontSize! * 1.5;

  /// The that the values passed are acceptable
  void _checks() {
    logger.check(
      inactiveTextStyle.fontSize != null && activeTextStyle.fontSize != null,
      message: "The text styles passed need to have a defined fontSize",
      raiseError: true,
    );
    logger.check(
      inactiveTextStyle.fontSize == activeTextStyle.fontSize,
      message: "The text styles passed need to have the same fontSize",
      raiseError: true,
    );
    logger.check(
      draggableText != null || !draggable,
      message:
          "If the widget is draggable then it needs to have a draggableText",
      raiseError: true,
    );
  }

  Widget _baseWidget({required bool active}) {
    return Container(
      color: active ? activeColor : inactiveColor,
      height: _getHeight(),
      width: double.infinity,
      child: DefaultTextStyle(
        style: active ? activeTextStyle : inactiveTextStyle,
        child: child,
      ),
    );
  }

  Widget _draggableWrapper(Widget child) {
    if (!draggable) return child;

    return Draggable<T>(
      data: draggableData,
      dragAnchorStrategy: (draggable, context, position) =>
          Offset(20, _getHeight() / 2),
      feedback: Material(
        child: Container(
          color: activeColor,
          child: Text(draggableText!, style: activeTextStyle),
        ),
      ),
      child: child,
    );
  }

  Widget _clickableWrapper(Widget child) {
    if (!clickable) return child;

    return GestureDetector(onTap: onTap, child: child);
  }

  @override
  Widget build(BuildContext context) {
    _checks();

    final inactiveChild = _clickableWrapper(
      _draggableWrapper(_baseWidget(active: false)),
    );
    final activeChild = _clickableWrapper(
      _draggableWrapper(_baseWidget(active: true)),
    );

    return hoverable
        ? Hoverable(
            hoveringCursor: hoveringCursor,
            unhoveredWidget: inactiveChild,
            hoveredWidget: activeChild,
          )
        : inactiveChild;
  }
}
