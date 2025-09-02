import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/track_info/subtag_editor.dart';
import 'package:fadeplay/desktop/widgets/track_info/tag_editor.dart';
import 'package:flutter/material.dart';

final logger = Logging("TrackArtistsEditor");

// TODO: Add autocomplete
class TrackArtistsEditor extends StatefulWidget {
  const TrackArtistsEditor({super.key, required this.track});

  final Track track;

  @override
  State<TrackArtistsEditor> createState() => _TrackArtistsEditorState();
}

class _TrackArtistsEditorState extends State<TrackArtistsEditor> {
  int _artistCount = 0;
  late final List<TextEditingController> _textControllers;
  late final List<TextEditingController> _subtextControllers;

  @override
  void initState() {
    super.initState();
    _artistCount = widget.track.artists.length;
    _textControllers = List.generate(_artistCount, (i) {
      final artist = widget.track.artists.entries.elementAt(i);
      return TextEditingController.fromValue(
        TextEditingValue(text: artist.key.name),
      );
    });
    _subtextControllers = List.generate(_artistCount, (i) {
      final artist = widget.track.artists.entries.elementAt(i);
      return TextEditingController.fromValue(
        TextEditingValue(text: artist.key.originalName ?? ""),
      );
    });
    final a = TextEditingController().addListener(
      () => logger.log(
        "Adding new artist",
      ), // FIXME: This doesn't work but I have to sleep
    );
  }

  @override
  void dispose() {
    for (var c in _textControllers) {
      c.dispose();
    }
    for (var c in _subtextControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MyTheme.paddingMedium,
        horizontal: MyTheme.paddingSmall,
      ),
      child: Center(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _artistCount + 1,
          scrollDirection: Axis.vertical,
          separatorBuilder: (_, _) => SizedBox(height: MyTheme.paddingSmall),

          itemBuilder: (_, i) => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: MyTheme.paddingTiny,
            children: [
              SubtagEditor(
                label: "Artist name",
                subtagLabel: "Original name",
                textFieldWidth: 430,
                textController: i < _artistCount ? _textControllers[i] : null,
                subTextController: i < _artistCount
                    ? _subtextControllers[i]
                    : null,
              ),
              TagEditor(
                textFieldWidth: 280,
              ), // TODO: This will be the artist type
              SizedBox(width: 20), // some padding for the scrollbar
            ],
          ),
        ),
      ),
    );
  }
}
