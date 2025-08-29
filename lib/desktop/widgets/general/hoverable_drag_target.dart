import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:flutter/material.dart';

/// The size of a `HoverableDragTarget` containing its hitbox and its visible part
///
/// `direction` represents the direction of the list that this `DragTarget` separates
///
/// The hitbox is measured by `fullHeight` and `fullWidth`
///
/// The visible part is measured by `visibleHeight` and `visibleWidth`
class HoverableDragTargetSize {
  HoverableDragTargetSize.listSeparator({
    required Axis listDirection,
    required double fullSize,
    double? visibleSize,
  }) {
    final realVisibleSize = visibleSize ?? fullSize;
    switch (listDirection) {
      case Axis.horizontal:
        visibleHeight = double.infinity;
        fullHeight = double.infinity;
        visibleWidth = realVisibleSize;
        fullWidth = fullSize;
        break;
      case Axis.vertical:
        visibleHeight = realVisibleSize;
        fullHeight = fullSize;
        visibleWidth = double.infinity;
        fullWidth = double.infinity;
        break;
    }
  }

  late final double? visibleHeight;
  late final double? fullHeight;
  late final double? visibleWidth;
  late final double? fullWidth;
}

/// A `DragTarget` that appears when it is hovered by a `Draggable` that it can accept
class HoverableDragTarget<T extends Object> extends StatefulWidget {
  const HoverableDragTarget({
    super.key,
    this.onWillAcceptWithDetails,
    this.onAcceptWithDetails,
    required this.size,
  });

  final bool Function(DragTargetDetails<T> details)? onWillAcceptWithDetails;
  final void Function(DragTargetDetails<T> details)? onAcceptWithDetails;
  final HoverableDragTargetSize size;

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

      hitTestBehavior: HitTestBehavior.translucent,
      builder: (_, _, _) => IgnorePointer(
        child: SizedBox(
          height: widget.size.fullHeight,
          width: widget.size.fullWidth,
          child: Center(
            child: SizedBox(
              height: widget.size.visibleHeight,
              width: widget.size.visibleWidth,
              child: hovering
                  ? ColoredBox(color: MyTheme.dragTargetColor)
                  : ColoredBox(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
