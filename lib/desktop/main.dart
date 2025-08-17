import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:media_kit/media_kit.dart';

class DesktopRootWidget extends StatelessWidget {
  const DesktopRootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadMusic(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            } else if (snapshot.hasError) {
              log(snapshot.error.toString());
              return Text("Error: ${snapshot.error}");
            } else {
              return Text(snapshot.data ?? "No result");
            }
          },
        ),
      ),
    );
  }

  Future<String> loadMusic() async {
    final music1 =
        "/home/livio/Musique/Musique/Songs/Super Mario Odyssey/SUPER MARIO ODYSSEY ORIGINAL SOUND TRACK/Steam Gardens.mp3";

    var content = "";

    // This is specific to windows and linux
    JustAudioMediaKit.ensureInitialized();
    JustAudioMediaKit.mpvLogLevel = MPVLogLevel.debug;
    JustAudioMediaKit.bufferSize = 8 * 1024 * 1024; // 8 MB
    JustAudioMediaKit.title = "Fadeplay";
    JustAudioMediaKit.protocolWhitelist = const ["file", "http", "https"];
    JustAudioMediaKit.pitch = false;
    JustAudioMediaKit.prefetchPlaylist = false;

    final player = AudioPlayer();

    final duration = await player.setFilePath(music1);

    if (duration == null) {
      content = "Music load failed";
    } else {
      content = "Music load succeeded";
      player.play();
    }

    return content;
  }
}
