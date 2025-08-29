import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/general/hoverable.dart';
import 'package:flutter/material.dart';

final logger = Logging("TextColumnElem");

class TextColumnElem<T extends Object> extends StatelessWidget {
  const TextColumnElem({
    super.key,
    required this.text,
    required this.inactiveTextStyle,
    this.activeTextStyle,
    required this.inactiveColor,
    this.activeColor,
    this.hoverable = false,
    this.hoveringCursor = MouseCursor.defer,
    this.clickable = false,
    this.onTap,
    this.draggable = false,
    this.draggableText,
    this.draggableData,
  });

  final String text;
  final TextStyle inactiveTextStyle;
  final TextStyle? activeTextStyle;
  final Color inactiveColor;
  final Color? activeColor;
  final bool hoverable;
  final MouseCursor hoveringCursor;
  final bool clickable;
  final void Function()? onTap;
  final bool draggable;
  final String? draggableText;
  final T? draggableData;

  /// The height of the element
  double getHeight() => inactiveTextStyle.fontSize! * 1.5;

  /// The that the values passed are acceptable
  void _checks() {
    logger.check(
      inactiveTextStyle.fontSize != null,
      message: "The text styles passed need to have a defined fontSize",
      raiseError: true,
    );
    logger.check(
      activeTextStyle == null ||
          inactiveTextStyle.fontSize == activeTextStyle!.fontSize,
      message: "The text styles passed need to have the same fontSize",
      raiseError: true,
    );
  }

  Widget _baseWidget({required bool active}) {
    return Container(
      color: active ? activeColor : inactiveColor,
      height: getHeight(),
      width: double.infinity,
      child: Text(text, style: active ? activeTextStyle : inactiveTextStyle),
    );
  }

  Widget _draggableWrapper(Widget child) {
    if (!draggable) return child;

    return Draggable<T>(
      data: draggableData,
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
