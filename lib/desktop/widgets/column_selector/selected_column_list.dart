import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/general/hoverable.dart';
import 'package:fadeplay/desktop/widgets/general/overlayed_list.dart';
import 'package:flutter/material.dart';

class SelectedColumnList extends StatefulWidget {
  const SelectedColumnList(
    this.selected,
    this.other, {
    super.key,
    required this.controller,
    required this.dragging,
  });

  final List<String> selected;
  final List<String> other;
  final ColumnBrowserController controller;
  final bool dragging;

  @override
  State<SelectedColumnList> createState() => _SelectedColumnListState();
}

class _SelectedColumnListState extends State<SelectedColumnList> {
  /// Index of the item that's being hovered
  int? hoveringIndex;

  Widget baseWidget({required String content, required Color color}) =>
      Container(
        height: MyTheme.textStyleNormal.fontSize! * 1.5,
        color: color,
        child: Text(content, style: MyTheme.textStyleNormal),
      );

  @override
  Widget build(BuildContext context) {
    return OverlayedList(
      direction: Axis.vertical,
      itemCount: widget.selected.length,
      edgeSeparators: true,
      scrollingEnabled: false,
      itemSizes: (_) => MyTheme.textStyleNormal.fontSize! * 1.5,
      separatorSizes: (_) => 5,
      itemBuilder: (_, index) => widget.dragging
          ? baseWidget(content: widget.selected[index], color: Colors.amber)
          : GestureDetector(
              child: Hoverable(
                hoveringCursor: SystemMouseCursors.click,
                unhoveredWidget: baseWidget(
                  content: widget.selected[index],
                  color: Colors.lightGreen,
                ),
                hoveredWidget: baseWidget(
                  content: widget.selected[index],
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                widget.controller.removeColumn(index: index);
              },
            ),
      separatorBuilder: (_, index) => DragTarget<String>(
        onWillAcceptWithDetails: (_) {
          setState(() => hoveringIndex = index);
          return true;
        },
        onLeave: (_) => setState(() => hoveringIndex = null),
        onAcceptWithDetails: (details) => {
          setState(() => hoveringIndex = null),
          widget.controller.insertColumn(
            columnId: details.data,
            index: index + 1,
          ),
        },
        builder: (_, _, _) => Container(
          color: hoveringIndex == index ? Colors.white : null,
          height: 5,
        ),
      ),
    );

    // return ListView.separated(
    //   scrollDirection: Axis.vertical,
    //   itemCount: widget.selected.length + 1,

    //   // exchanged separator and item to have separators at the edges
    //   separatorBuilder: (context, index) => widget.dragging
    //       ? baseWidget(content: widget.selected[index])
    //       : GestureDetector(
    //           child: Hoverable(
    //             hoveringCursor: SystemMouseCursors.click,
    //             unhoveredWidget: baseWidget(content: widget.selected[index]),
    //             hoveredWidget: Container(
    //               color: Colors.blue,
    //               child: baseWidget(content: widget.selected[index]),
    //             ),
    //           ),
    //           onTap: () {
    //             widget.controller.removeColumn(index: index);
    //           },
    //         ),
    //   itemBuilder: (context, index) => DragTarget<String>(
    //     onWillAcceptWithDetails: (_) {
    //       setState(() => hoveringIndex = index);
    //       return true;
    //     },
    //     onLeave: (_) => setState(() => hoveringIndex = null),
    //     onAcceptWithDetails: (details) => {
    //       setState(() => hoveringIndex = null),
    //       widget.controller.insertColumn(
    //         columnId: details.data,
    //         index: index,
    //       ),
    //     },
    //     builder: (context, candidateData, rejectedData) => Container(
    //       color: hoveringIndex == index ? Colors.white : Colors.red,
    //       height: 5,
    //     ),
    //   ),
    // );
  }
}
