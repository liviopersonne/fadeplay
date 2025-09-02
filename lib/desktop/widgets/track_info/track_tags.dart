import 'dart:io';

import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/track_info/rating_editor.dart';
import 'package:fadeplay/desktop/widgets/track_info/subtag_editor.dart';
import 'package:fadeplay/desktop/widgets/track_info/tag_editor.dart';
import 'package:flutter/material.dart';

class TrackTagsEditor extends StatelessWidget {
  const TrackTagsEditor({super.key, required this.track});

  final Track track;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MyTheme.paddingMedium,
        horizontal: MyTheme.paddingSmall,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: 230,
                  child: track.imageUri != null
                      ? Image.file(File.fromUri(track.imageUri!))
                      : ColoredBox(
                          color: MyTheme.colorBackgroundLight,
                          child: Center(
                            child: Text(
                              "No image",
                              style: MyTheme.textStyleNormal,
                            ),
                          ),
                        ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Rating:", style: MyTheme.textStyleNormal),
                    RatingEditor(starCount: 5),
                  ],
                ),

                TagEditor(label: "Safety:", textFieldWidth: 200),
                TagEditor(label: "Lyrics:", active: false, textFieldWidth: 200),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.paddingSmall),
            child: VerticalDivider(thickness: 3),
          ),
          Expanded(
            flex: 2,
            child: Column(
              spacing: MyTheme.paddingTiny,
              children: [
                SubtagEditor(label: "Title:", subtagLabel: "Original title:"),
                TagEditor(label: "Artist:", openDetails: () => ()),
                // TagEditor(label: "All artists:", active: true),
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
                      label: "of",
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
                    TagEditor(label: "of", textFieldWidth: 50),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: MyTheme.paddingTiny),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TagEditor(label: "Year:", textFieldWidth: 142.2),
                    ],
                  ),
                ),
                TagEditor(label: "Moods:", active: true),
                TagEditor(label: "Instruments:", active: true),
                // TagEditor(label: "Lyrics", active: false),
                // TagEditor(label: "Start time", active: true),
                // TagEditor(label: "End time", active: true),
                // TagEditor(label: "Created at", active: false),
                // TagEditor(label: "File", active: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
