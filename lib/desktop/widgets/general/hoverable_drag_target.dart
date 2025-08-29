import 'package:flutter/material.dart';

class HoverableDragTarget<T extends Object> extends StatefulWidget {
  const HoverableDragTarget({
    super.key,
    this.onWillAcceptWithDetails,
    this.onAcceptWithDetails,
    this.height,
    this.width,
  });

  final bool Function(DragTargetDetails<T> details)? onWillAcceptWithDetails;
  final void Function(DragTargetDetails<T> details)? onAcceptWithDetails;
  final double? height;
  final double? width;

  @override
  State<HoverableDragTarget<T>> createState() => _HoverableDragTargetState<T>();
}

class _HoverableDragTargetState<T extends Object>
    extends State<HoverableDragTarget<T>> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      onWillAcceptWithDetails: (details) {
        setState(() => hovering = true);
        // accept by default
        return widget.onWillAcceptWithDetails?.call(details) ?? true;
      },
      onLeave: (_) => setState(() => hovering = false),
      onAcceptWithDetails: (details) {
        setState(() => hovering = false);
        return widget.onAcceptWithDetails?.call(details);
      },
      builder: (_, _, _) => Container(
        color: hovering ? Colors.white : null,
        height: widget.height,
        width: widget.width,
      ),
    );
  }
}
