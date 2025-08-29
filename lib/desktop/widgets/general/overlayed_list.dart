import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:flutter/material.dart';

final logger = Logging("OverlayedList");

/// Like a `ListView.separated` but the separators are overlayed above
/// or under the elements instead of being placed between them.
///
/// You can also choose to have leading and trailing separators
/// that will be indexed at `-1` and `itemCount-1`
class OverlayedList extends StatefulWidget {
  const OverlayedList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.direction = Axis.vertical,
    this.edgeSeparators = false,
    required this.itemSizes,
    required this.separatorSizes,
    this.scrollingEnabled = true,
  });

  final int itemCount;
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index) separatorBuilder;
  final Axis direction;
  final bool edgeSeparators;
  final double Function(int index) itemSizes;
  final double Function(int index) separatorSizes;
  final bool scrollingEnabled;

  @override
  State<OverlayedList> createState() => _OverlayedListState();
}

/// NOTE: This is a stateful widget because we need to dispose the scrollController at the end
class _OverlayedListState extends State<OverlayedList> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// The position to put an overlayed object at
  Positioned _positioned({
    required double currOffset,
    required double separatorSize,
    required double scrollOffset,
    required Widget child,
  }) {
    final realOffset = currOffset - separatorSize / 2 - scrollOffset;
    return widget.direction == Axis.horizontal
        ? Positioned(left: realOffset, top: 0, bottom: 0, child: child)
        : Positioned(top: realOffset, left: 0, right: 0, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> overlayedContent = [];
    double offset = widget.itemSizes(0);

    /// One of the overlayed objects
    Widget overlayedElem(double currOffset, int index) {
      return widget.scrollingEnabled
          ? AnimatedBuilder(
              animation: _scrollController,
              builder: (_, _) => _positioned(
                currOffset: currOffset,
                separatorSize: widget.separatorSizes(index),
                scrollOffset: _scrollController.hasClients
                    ? _scrollController.offset
                    : 0,
                // IgnorePointer is used so we can still scroll on the separator
                child: IgnorePointer(
                  child: widget.separatorBuilder(context, index),
                ),
              ),
            )
          : _positioned(
              currOffset: currOffset,
              separatorSize: widget.separatorSizes(index),
              scrollOffset: 0.0,
              child: widget.separatorBuilder(context, index),
            );
    }

    for (int i = 0; i < widget.itemCount - 1; i++) {
      // we need to create a local variable so it doesn't get updated a offset changes
      final currentOffset = offset;
      overlayedContent.add(overlayedElem(currentOffset, i));
      offset += widget.itemSizes(i + 1);
    }

    if (widget.edgeSeparators) {
      overlayedContent.addAll([
        overlayedElem(0, -1),
        if (widget.itemCount > 0) overlayedElem(offset, widget.itemCount - 1),
      ]);
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        ListView.builder(
          controller: _scrollController,
          physics: widget.scrollingEnabled
              ? ScrollPhysics()
              : NeverScrollableScrollPhysics(),
          itemBuilder: widget.itemBuilder,
          itemCount: widget.itemCount,
          scrollDirection: widget.direction,
        ),
        ...overlayedContent,
      ],
    );
  }
}
