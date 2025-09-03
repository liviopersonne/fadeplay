import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/data/tracks/track.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/rectangle_dialog.dart';
import 'package:fadeplay/desktop/widgets/track_info/track_artists.dart';
import 'package:fadeplay/desktop/widgets/track_info/track_tags.dart';
import 'package:flutter/material.dart';

final logger = Logging("TrackInfoPage");

class TrackInfoDialog {
  const TrackInfoDialog({required this.track});

  final Track track;

  void showAsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return RectangleDialog(
          title: "Track info",
          height: 558,
          width: 860,
          pages: {
            "Tags": TrackTagsEditor(track: track),
            "Artists": TrackArtistsEditor(track: track),
            "Lyrics": ColorSizeBox(color: Colors.amber, child: Text("Lyrics")),
            "File": ColorSizeBox(color: Colors.amber, child: Text("File")),
          },
          onConfirm: () {},
        );
      },
    );
  }
}
