import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:flutter/material.dart';

final logger = Logging("FocusOnClick");

/// A widget that gets focused than you click on it.
///
/// You can pass a `focusNode` if you want to allow
/// other widgets to  focus or unfocus this.
///
/// You can also pass some callbacks for the `gestureDetector`
class FocusOnClick extends StatefulWidget {
  const FocusOnClick({
    super.key,
    required this.unfocusedWidget,
    required this.focusedWidget,
    this.focusNode,
    this.autofocus = false,
    this.onTap,
    this.onSecondaryTap,
    this.onTapDown,
    this.onSecondaryTapDown,
    this.onDoubleTap,
  });

  final Widget unfocusedWidget;
  final Widget focusedWidget;
  final FocusNode? focusNode;
  final bool autofocus;
  final void Function()? onTap;
  final void Function()? onSecondaryTap;
  final void Function(TapDownDetails details)? onTapDown;
  final void Function(TapDownDetails details)? onSecondaryTapDown;
  final void Function()? onDoubleTap;

  @override
  State<FocusOnClick> createState() => _FocusOnClickState();
}

class _FocusOnClickState extends State<FocusOnClick> {
  FocusNode? _localFocusNode;

  @override
  void initState() {
    if (widget.focusNode == null) {
      _localFocusNode = FocusNode();
    }
    super.initState();
  }

  @override
  void dispose() {
    _localFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode realFocusNode = widget.focusNode ?? _localFocusNode!;

    return Focus(
      autofocus: widget.autofocus,
      focusNode: realFocusNode,
      onFocusChange: (_) => setState(() => ()),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(realFocusNode);
          widget.onTap?.call();
        },
        onSecondaryTap: widget.onSecondaryTap,
        onTapDown: widget.onTapDown,
        onSecondaryTapDown: widget.onSecondaryTapDown,
        onDoubleTap: widget.onDoubleTap,

        child: realFocusNode.hasFocus
            ? widget.focusedWidget
            : widget.unfocusedWidget,
      ),
    );
  }
}
