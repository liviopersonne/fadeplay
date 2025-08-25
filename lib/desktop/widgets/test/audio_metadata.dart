import 'dart:io';

import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/tracks/audio_metadata.dart';
import 'package:flutter/material.dart';

final logger = Logging("TestAudioMetadata");

class TestAudioMetadata extends StatelessWidget {
  const TestAudioMetadata({super.key});

  final music1 = "/home/livio/Bureau/fadeplay_tests/timber_hearth.mp3";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadMetadata(),
          // future: writeMetadata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            } else if (snapshot.hasError) {
              logger.error(snapshot.error.toString());
              return Text("Error: ${snapshot.error}");
            } else {
              return Text(snapshot.data ?? "No result");
            }
          },
        ),
      ),
    );
  }

  Future<String> loadMetadata() async {
    final meta = MetadataReader.readFileMetadata(File(music1));

    final short = meta?.toString() ?? "No metadata found";
    final long = meta?.fullString() ?? "No metadata found";

    logger.log(short);

    return long;
  }

  Future<String> writeMetadata() async {
    final meta = TrackMetadata(
      title: "New Title",
      artist: "New Artist",
      album: "New Album",
      cdNumber: 1,
      cdTotal: 5,
      trackNumber: 12,
      trackTotal: 20,
      year: 2010,
    );

    final og = TrackMetadata(
      title: "Timber Hearth",
      artist: "Andrew Prahlow",
      album: "Outer Wilds (Original Soundtrack)",
      trackNumber: 1,
      trackTotal: 28,
    );

    MetadataReader.writeFileMetadata(meta, File(music1));

    return "Success";
  }
}

/* FIXME: 
  [x] Artiste de l'album au lieu de artiste
  [x] Genre dupliqué
  [x] Année pas lue
*/
