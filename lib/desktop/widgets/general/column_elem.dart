import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/focus_on_click.dart';
import 'package:fadeplay/desktop/widgets/general/hoverable.dart';
import 'package:flutter/material.dart';

final logger = Logging("ColumnElem");

/// This is a central widget which encapsulates lots of things that are used a lot throughout this app.
/// Its particularity is that it has a fixed height that can be calculated through `getHeight`, and which depends
/// only on the font size of the `TextStyle` passed.
///
/// This widget can be either active or inactive, we pass a `TextStyle` and a `Color` for those 2 states.
/// Since there is a fixed height, the 2 `TextStyle`s passed must have the same font size.
///
/// The `minimumWidth` parameter decides whether the width is limited to the width of `child` or not.
///
/// There are 4 behaviours encapsulated in this widget:
///
/// 1. **Hovering**: if `hoverable` is true then the widget becomes active when hovering it with the mouse,
/// and the cursor become `hoveringCursor`.///
///
/// 2. **Clicking**: if `clickable` is true then we can click on the widget and we can pass a few callbacks.
///
/// 3. **Dragging**: if `draggable` is true then we can drag the widget to its corresponding drag targets.
/// The data passed in that drag is `draggableData`, and the feedback widget has the same style as the
/// active widget but with only a string inside: `draggableText`..
/// There is also a `dragNotifier` which makes the widget undraggable if it is true. This is to deactivate
/// interactivity on all other widgets in a list if we are currently dragging one.
///
/// 4. **Focusing**: if `focusable` is true then we can focus this widget by clicking on it. If a widget
/// is focused then it becomes active. This is useful for listening for hotkeys. If you want to be able
/// to focus / unfocus the widget from outside, then you can provide a `focusNode`.
class ColumnElem<T extends Object> extends StatelessWidget {
  const ColumnElem({
    super.key,
    required this.child,
    required this.inactiveTextStyle,
    TextStyle? activeTextStyle,
    this.inactiveColor,
    Color? activeColor,
    this.minimumWidth = false,
    this.hoverable = false,
    this.hoveringCursor = MouseCursor.defer,
    this.clickable = false,
    this.onTap,
    this.onSecondaryTap,
    this.onTapDown,
    this.onSecondaryTapDown,
    this.onDoubleTap,
    this.draggable = false,
    this.dragNotifier,
    this.draggableText,
    this.draggableData,
    this.focusable = false,
    this.focusNode,
  }) : activeTextStyle = activeTextStyle ?? inactiveTextStyle,
       activeColor = activeColor ?? inactiveColor;

  final Widget child;
  final TextStyle inactiveTextStyle;
  final TextStyle activeTextStyle;
  final Color? inactiveColor;
  final Color? activeColor;
  final bool minimumWidth;
  final bool hoverable;
  final MouseCursor hoveringCursor;
  final bool clickable;
  final void Function()? onTap;
  final void Function()? onSecondaryTap;
  final void Function(TapDownDetails details)? onTapDown;
  final void Function(TapDownDetails details)? onSecondaryTapDown;
  final void Function()? onDoubleTap;
  final bool draggable;
  final ValueNotifier<bool>? dragNotifier;
  final String? draggableText;
  final T? draggableData;
  final bool focusable;
  final FocusNode? focusNode;

  static double getHeight(TextStyle textStyle) {
    logger.check(
      textStyle.fontSize != null,
      message: "The text style passed needs to have a defined fontSize",
      raiseError: true,
    );
    return textStyle.fontSize! * 1.8;
  }

  /// The height of the element
  double _getHeight() => getHeight(inactiveTextStyle);

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
      (draggableText != null && dragNotifier != null) || !draggable,
      message:
          "If the widget is draggable then it needs to have draggableText and a dragNotifier",
      raiseError: true,
    );
  }

  Widget _baseWidget({required bool active}) {
    return ColorSizeBox(
      color: active ? activeColor : inactiveColor,
      height: _getHeight(),
      width: double.infinity,
      child: DefaultTextStyle(
        style: active ? activeTextStyle : inactiveTextStyle,
        child: Align(alignment: AlignmentGeometry.centerLeft, child: child),
      ),
    );
  }

  Widget _draggableWrapper(Widget child) {
    if (!draggable) return child;

    return Draggable<T>(
      data: draggableData,
      onDragStarted: () => dragNotifier?.value = true,
      onDragEnd: (_) => dragNotifier?.value = false,
      dragAnchorStrategy: (draggable, context, position) =>
          Offset(20, _getHeight() / 2),
      feedback: Material(
        child: ColorSizeBox(
          color: activeColor,
          child: Text(draggableText!, style: activeTextStyle),
        ),
      ),
      child: child,
    );
  }

  Widget _focusableClickableWrapper(Widget Function(bool) builder) {
    return switch ((focusable, clickable)) {
      (false, false) => builder(false),
      (false, true) => GestureDetector(
        onTap: onTap,
        onSecondaryTap: onSecondaryTap,
        onTapDown: onTapDown,
        onSecondaryTapDown: onSecondaryTapDown,
        onDoubleTap: onDoubleTap,
        child: builder(false),
      ),
      (true, false) => FocusOnClick(builder: builder, focusNode: focusNode),
      (true, true) => FocusOnClick(
        builder: builder,
        focusNode: focusNode,
        onTap: onTap,
        onTapDown: onTapDown,
        onSecondaryTap: onSecondaryTap,
        onSecondaryTapDown: onSecondaryTapDown,
        onDoubleTap: onDoubleTap,
      ),
    };
  }

  Widget _expandedWrapper(Widget child) {
    return minimumWidth ? IntrinsicWidth(child: child) : child;
  }

  @override
  Widget build(BuildContext context) {
    _checks();

    final inactiveChild = _focusableClickableWrapper(
      (focused) => _draggableWrapper(_baseWidget(active: focused)),
    );
    final activeChild = _focusableClickableWrapper(
      (_) => _draggableWrapper(_baseWidget(active: true)),
    );

    return _expandedWrapper(
      hoverable && !(dragNotifier?.value ?? false)
          ? Hoverable(
              hoveringCursor: hoveringCursor,
              unhoveredWidget: inactiveChild,
              hoveredWidget: activeChild,
              disableNotifier: dragNotifier,
            )
          : inactiveChild,
    );
  }
}
