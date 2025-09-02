import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/rectangle_dialog.dart';
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
          height: 560,
          width: 860,
          pages: {
            "Tags": TrackTagsPage(track: track),
            "Artists": ColorSizeBox(
              color: Colors.amber,
              child: Text("Artists"),
            ),
            "Lyrics": ColorSizeBox(color: Colors.amber, child: Text("Lyrics")),
            "File": ColorSizeBox(color: Colors.amber, child: Text("File")),
          },
          onConfirm: () {},
        );
      },
    );
  }
}
