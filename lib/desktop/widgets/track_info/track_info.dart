import 'dart:io';

import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/track_info/tag_editor.dart';
import 'package:flutter/material.dart';

final logger = Logging("TrackInfoPage");

class TrackInfoPage extends StatelessWidget {
  const TrackInfoPage({super.key, required this.track});

  final Track track;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    textController.text = "azertyuiop";
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox.square(
                dimension: 100,
                child: track.imageUri != null
                    ? Image.file(File.fromUri(track.imageUri!))
                    : Text("No image"),
              ),

              Text("Rating"),
            ],
          ),
        ),
        VerticalDivider(thickness: 3),
        Expanded(
          flex: 5,
          child: Column(
            spacing: MyTheme.paddingTiny,
            children: [
              TagEditor(label: "Title:", openDetails: () => ()),
              TagEditor(label: "Original title:", active: true),
              TagEditor(label: "Artist:", openDetails: () => ()),
              TagEditor(label: "All artists:", active: true),
              TagEditor(label: "Album:", openDetails: () => ()),
              TagEditor(label: "Source:", active: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: MyTheme.paddingMedium,
                children: [
                  TagEditor(
                    label: "Track:",
                    numbersOnly: true,
                    textFieldWidth: 50,
                  ),
                  TagEditor(
                    label: "of:",
                    numbersOnly: true,
                    textFieldWidth: 50,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: MyTheme.paddingMedium,
                children: [
                  TagEditor(label: "Disk:", textFieldWidth: 50),
                  TagEditor(label: "of:", textFieldWidth: 50),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [TagEditor(label: "Year:", textFieldWidth: 146)],
              ),
              // TagEditor(label: "Moods", active: true),
              // TagEditor(label: "Instruments", active: true),
              // TagEditor(label: "Safety", active: true),
              // TagEditor(label: "Lyrics", active: false),
              // TagEditor(label: "Start time", active: true),
              // TagEditor(label: "End time", active: true),
              // TagEditor(label: "Created at", active: false),
              // TagEditor(label: "File", active: false),
            ],
          ),
        ),
      ],
    );
  }
}
