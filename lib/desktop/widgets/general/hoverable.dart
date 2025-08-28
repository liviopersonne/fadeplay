import 'package:flutter/material.dart';

/// A widget that changes state when hovered
class Hoverable extends StatefulWidget {
  const Hoverable({
    super.key,
    required this.hoveredWidget,
    required this.unhoveredWidget,
    this.hoveringCursor = MouseCursor.defer,
  });

  final Widget hoveredWidget;
  final Widget unhoveredWidget;
  final MouseCursor hoveringCursor;

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.hoveringCursor,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: hovering ? widget.hoveredWidget : widget.unhoveredWidget,
    );
  }
}
