import 'dart:math';

import 'package:fadeplay/desktop/widgets/general/overlayed_list.dart';
import 'package:flutter/material.dart';

class TestOverlayedList extends StatelessWidget {
  const TestOverlayedList({super.key});

  Color randomColor() =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withAlpha(255);

  List<double> randomSizes(int length, double min, double max) =>
      List.generate(length, (_) => Random().nextDouble() * (max - min) + min);

  @override
  Widget build(BuildContext context) {
    final itemCount = 10;
    final sizes = randomSizes(itemCount, 50, 100);
    final separatorSizes = randomSizes(itemCount + 2, 5, 20);
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: 500,
          color: Colors.grey,
          child: OverlayedList(
            itemCount: itemCount,
            itemBuilder: (_, i) => Container(
              color: randomColor(),
              width: sizes[i],
              height: sizes[i],
              child: Text("Elem $i"),
            ),
            separatorBuilder: (_, i) => Container(
              color: randomColor().withAlpha(150),
              width: separatorSizes[i + 1],
              height: separatorSizes[i + 1],
            ),
            itemSizes: (i) => sizes[i],
            separatorSizes: (i) => separatorSizes[i + 1],
            direction: Axis.horizontal,
            edgeSeparators: true,
            scrollingEnabled: true,
            scrollController: ScrollController(),
          ),
        ),
      ),
    );
  }
}
