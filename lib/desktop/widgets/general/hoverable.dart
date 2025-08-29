import 'package:flutter/material.dart';

/// A widget that changes state when hovered
///
/// When `disableNotifier` is true, hovering is disabled
class Hoverable extends StatefulWidget {
  const Hoverable({
    super.key,
    required this.hoveredWidget,
    required this.unhoveredWidget,
    this.hoveringCursor = MouseCursor.defer,
    this.disableNotifier,
  });

  final Widget hoveredWidget;
  final Widget unhoveredWidget;
  final MouseCursor hoveringCursor;
  final ValueNotifier<bool>? disableNotifier;

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    if (widget.disableNotifier == null) {
      return MouseRegion(
        cursor: widget.hoveringCursor,
        onEnter: (_) => setState(() => hovering = true),
        onExit: (_) => setState(() => hovering = false),
        child: hovering ? widget.hoveredWidget : widget.unhoveredWidget,
      );
    } else {
      return ValueListenableBuilder<bool>(
        valueListenable: widget.disableNotifier!,
        builder: (_, disabled, _) => MouseRegion(
          cursor: widget.hoveringCursor,
          onEnter: (_) => setState(() => hovering = true),
          onExit: (_) => setState(() => hovering = false),
          child: (hovering && !disabled)
              ? widget.hoveredWidget
              : widget.unhoveredWidget,
        ),
      );
    }
  }
}
