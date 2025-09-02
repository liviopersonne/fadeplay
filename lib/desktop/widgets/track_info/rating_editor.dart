import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';

/// A widget with clickable stars which represent a rating
///
/// - `starCount` can go from 1 to 5
class RatingEditor extends StatefulWidget {
  RatingEditor({super.key, int starCount = 5, int starHeight = 26})
    : starCount = starCount.clamp(1, 5).toInt(),
      starHeight = starHeight - (starHeight % 2);
  // starHeight needs to be pair to avoid rounding errors in sizes

  final double starHeight;
  final int starCount;

  final ValueNotifier<int?> _rating = ValueNotifier(null);
  int? get rating => _rating.value;

  @override
  State<RatingEditor> createState() => _RatingEditorState();
}

class _RatingEditorState extends State<RatingEditor> {
  int? _hoveringRating;
  int _currentRating = 0;

  final inactiveColor = Colors.white;
  final hoveredColor = Colors.lightBlue;
  final activeColor = Colors.blue;

  Color _halfStarColor(int index) {
    if (_hoveringRating != null) {
      return _hoveringRating! <= index ? inactiveColor : hoveredColor;
    } else {
      return _currentRating <= index ? inactiveColor : activeColor;
    }
  }

  Widget _starClickDetector(int index) {
    return Stack(
      children: [
        Row(
          children: List.generate(2, (i) {
            final localRating = 2 * index + i + 1;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _hoveringRating = localRating),
              onExit: (_) => setState(() => _hoveringRating = null),
              child: GestureDetector(
                onTap: () => setState(() {
                  _currentRating = localRating;
                  widget._rating.value = localRating;
                }),
                child: SizedBox(
                  width: widget.starHeight / 2,
                  height: widget.starHeight,
                  child: Text(""), // I need this so that the button exists
                ),
              ),
            );
          }),
        ),
        IgnorePointer(
          child: PhysicalShape(
            clipper: ShapeBorderClipper(shape: StarBorder()),
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                ColorSizeBox(
                  width: widget.starHeight / 2,
                  height: widget.starHeight,
                  color: _halfStarColor(2 * index),
                ),
                ColorSizeBox(
                  width: widget.starHeight / 2,
                  height: widget.starHeight,
                  color: _halfStarColor(2 * index + 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.starHeight,
      width: widget.starHeight * widget.starCount,
      child: ListView.builder(
        itemCount: widget.starCount,
        scrollDirection: Axis.horizontal,

        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) => SizedBox.square(
          dimension: widget.starHeight,
          child: _starClickDetector(i),
        ),
      ),
    );
  }
}
