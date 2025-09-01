import 'dart:io';

import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';

final logger = Logging("TrackInfoPage");

class TagEditor extends StatelessWidget {
  const TagEditor({
    super.key,
    required this.label,
    required this.active,
    this.openDetails,
    this.controller,
  });

  final String label;
  final bool active;
  final void Function()? openDetails;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: MyTheme.textStyleNormal),
        SizedBox(
          width: 300,
          child: TextField(
            controller: controller,
            style: MyTheme.textStyleNormal,
            readOnly: !active,
            showCursor: true,
            cursorColor: MyTheme.textStyleNormal.color,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              filled: true,
              fillColor: active
                  ? MyTheme.colorBackgroundLight
                  : MyTheme.colorBackgroundDark,
              isDense: true,
              suffixIcon: active && openDetails != null
                  ? MyButton(text: "+", onTap: openDetails)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

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

              TextField(readOnly: false, controller: textController),
            ],
          ),
        ),
        VerticalDivider(thickness: 3),
        Expanded(
          flex: 5,
          child: Column(
            spacing: 40,
            children: [
              ColorSizeBox(color: Colors.lightBlue, height: 200, width: 100),
              TagEditor(label: "Tag 1", active: true),
              TagEditor(
                label: "Tag 67",
                active: true,
                openDetails: () => logger.log("Hey !"),
              ),
              TagEditor(
                label: "Random tag",
                active: false,
                controller: textController,
                openDetails: () =>
                    logger.error("That's not supposed to happen"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
