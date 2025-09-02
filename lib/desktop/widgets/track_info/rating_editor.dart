import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';

/// A widget with clickable stars which represent a rating
///
/// - `starCount` can go from 1 to 5
class RatingEditor extends StatefulWidget {
  RatingEditor({super.key, int starCount = 5, int starHeight = 22})
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

  final inactiveColor = MyTheme.colorBackgroundVeryLight;
  final hoveredColor = Colors.lightBlue;
  final activeColor = Colors.white;

  Color _halfStarColor(int index) {
    if (_hoveringRating != null) {
      return _hoveringRating! <= index ? inactiveColor : hoveredColor;
    } else {
      return _currentRating <= index ? inactiveColor : activeColor;
    }
  }

  Widget _ratingClickDetector(int rating) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveringRating = rating),
      onExit: (_) => setState(() => _hoveringRating = null),
      child: GestureDetector(
        onTap: () => setState(() {
          _currentRating = rating;
          widget._rating.value = rating;
        }),
        child: SizedBox(
          width: widget.starHeight / 2,
          height: widget.starHeight,
          child: Text(""), // I need this so that the button exists
        ),
      ),
    );
  }

  Widget _starClickDetector(int index) {
    return Stack(
      children: [
        Row(
          children: List.generate(2, (i) {
            final localRating = 2 * index + i + 1;
            return _ratingClickDetector(localRating);
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
      width: widget.starHeight * (widget.starCount + 1),
      child: ListView.builder(
        itemCount: widget.starCount + 1,
        scrollDirection: Axis.horizontal,

        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) => i == 0
            ? SizedBox.square(
                dimension: widget.starHeight,
                child: _ratingClickDetector(0),
              )
            : SizedBox.square(
                dimension: widget.starHeight,
                child: _starClickDetector(i - 1),
              ),
      ),
    );
  }
}
