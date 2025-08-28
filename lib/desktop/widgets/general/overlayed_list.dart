import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:flutter/material.dart';

final logger = Logging("OverlayedList");

/// Like a `ListView.separated` but the separators are overlayed above
/// or under the elements instead of being placed between them.
///
/// You can also choose to have leading and trailing separators
class OverlayedList extends StatelessWidget {
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
    this.scrollController,
  });

  final int itemCount;
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index) separatorBuilder;
  final Axis direction;
  final bool edgeSeparators;
  final double Function(int index) itemSizes;
  final double Function(int index) separatorSizes;
  final bool scrollingEnabled;
  final ScrollController? scrollController;

  /// The position to put an overlayed object at
  Positioned _positioned({
    required double currOffset,
    required double separatorSize,
    required double scrollOffset,
    required Widget child,
  }) {
    final realOffset = currOffset - separatorSize / 2 - scrollOffset;
    return direction == Axis.horizontal
        ? Positioned(left: realOffset, top: 0, bottom: 0, child: child)
        : Positioned(top: realOffset, left: 0, right: 0, child: child);
  }

  @override
  Widget build(BuildContext context) {
    logger.check(
      (scrollController == null) == (scrollingEnabled == false),
      message:
          "scrollController can be null if and only if scrolling is disabled",
      raiseError: true,
    );

    final List<Widget> overlayedContent = [];
    double offset = 0;

    /// One of the overlayed objects
    Widget overlayedElem(double currOffset, int index) {
      return scrollingEnabled
          ? AnimatedBuilder(
              animation: scrollController!,
              builder: (_, _) => _positioned(
                currOffset: currOffset,
                separatorSize: separatorSizes(index),
                scrollOffset: scrollController!.hasClients
                    ? scrollController!.offset
                    : 0,
                child: separatorBuilder(context, index),
              ),
            )
          : _positioned(
              currOffset: currOffset,
              separatorSize: separatorSizes(index),
              scrollOffset: 0.0,
              child: separatorBuilder(context, index),
            );
    }

    for (int i = 0; i < itemCount; i++) {
      offset += itemSizes(i);
      // we need to create a local variable so it doesn't get updated a offset changes
      final currentOffset = offset;
      overlayedContent.add(overlayedElem(currentOffset, i));
    }
    if (edgeSeparators) {
      overlayedContent.addAll([
        overlayedElem(0, -1),
        overlayedElem(offset, itemCount),
      ]);
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        ListView.builder(
          controller: scrollController,
          physics: scrollingEnabled
              ? ScrollPhysics()
              : NeverScrollableScrollPhysics(),
          itemBuilder: itemBuilder,
          itemCount: itemCount,
          scrollDirection: direction,
        ),
        ...overlayedContent,
      ],
    );
  }
}
