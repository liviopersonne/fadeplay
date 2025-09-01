import 'package:fadeplay/desktop/objects/hotkeys/hotkey_scope.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final logger = Logging("columnBrowserHotkeyScope");

final columnBrowserHotkeyScope = HotkeyScope(
  id: "columnBrowser",
  shortcuts: {
    SingleActivator(LogicalKeyboardKey.enter, shift: true):
        OpenTrackDetailsIntent(),
  },
);

class OpenTrackDetailsIntent extends Intent {}

class OpenTrackDetailsAction extends Action<OpenTrackDetailsIntent> {
  OpenTrackDetailsAction({required this.track});

  final Track track;

  @override
  Object? invoke(OpenTrackDetailsIntent intent) {
    // TODO: implement invoke
    logger.log("Opening track details ${track.title}");
    return null;
  }
}
