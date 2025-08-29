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
    this.draggableFeedback,
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
  final Widget? draggableFeedback;
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

  Widget _inactiveBaseWidget() => Container(
    color: inactiveColor,
    height: getHeight(),
    width: double.infinity,
    child: Text(text, style: inactiveTextStyle),
  );

  Widget _activeBaseWidget() => Container(
    color: activeColor,
    height: getHeight(),
    width: double.infinity,
    child: Text(text, style: activeTextStyle),
  );

  @override
  Widget build(BuildContext context) {
    _checks();

    return Hoverable(
      hoveringCursor: hoveringCursor,
      unhoveredWidget: _inactiveBaseWidget(),
      hoveredWidget: GestureDetector(
        onTap: onTap,
        child: Draggable<T>(
          data: draggableData,
          feedback: Material(child: draggableFeedback!),
          child: _activeBaseWidget(),
        ),
      ),
    );
  }
}
