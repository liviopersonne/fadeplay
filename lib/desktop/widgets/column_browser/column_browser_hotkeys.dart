import 'package:fadeplay/desktop/objects/hotkeys/hotkey_scope.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/widgets/track_info/track_info.dart';
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
  OpenTrackDetailsAction({required this.context, required this.track});

  final BuildContext context;
  final Track track;

  @override
  Object? invoke(OpenTrackDetailsIntent intent) {
    logger.log("Opening track details ${track.title}");
    TrackInfoDialog(track: track).showAsDialog(context);
    return null;
  }
}
