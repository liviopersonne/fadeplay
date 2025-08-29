import 'package:fadeplay/desktop/widgets/general/hoverable.dart';
import 'package:flutter/material.dart';

class SelectableColumnList extends StatefulWidget {
  const SelectableColumnList(
    this.selected,
    this.other, {
    super.key,
    required this.setDragging,
    required this.dragging,
  });

  final List<String> selected;
  final List<String> other;
  final void Function(bool) setDragging;
  final bool dragging;

  @override
  State<SelectableColumnList> createState() => _SelectableColumnListState();
}

class _SelectableColumnListState extends State<SelectableColumnList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.other.length,
      itemBuilder: (context, index) => Draggable<String>(
        data: widget.other[index],
        onDragStarted: () => widget.setDragging(true),
        onDragEnd: (_) => widget.setDragging(false),
        feedback: Material(child: Text(widget.other[index])),
        childWhenDragging: Text(widget.other[index]),
        child: widget.dragging
            ? Text(widget.other[index])
            : Hoverable(
                hoveredWidget: Container(
                  color: Colors.lightBlue,
                  child: Text(widget.other[index]),
                ),
                unhoveredWidget: Text(widget.other[index]),
                hoveringCursor: SystemMouseCursors.grab,
              ),
      ),
    );
  }
}
