import 'package:fadeplay/desktop/db/schemas/enums.dart';
import 'package:fadeplay/desktop/objects/tracks/album.dart';
import 'package:fadeplay/desktop/objects/tracks/artist.dart';
import 'package:fadeplay/desktop/objects/tracks/source.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/track_info/track_info.dart';
import 'package:flutter/material.dart';

class TestTrackInfo extends StatelessWidget {
  const TestTrackInfo({super.key});

  final music = "/home/livio/Bureau/fadeplay_tests/timber_hearth.mp3";
  final image1 = "/home/livio/Bureau/fadeplay_tests/img1.png";
  final image2 = "/home/livio/Bureau/fadeplay_tests/img2.png";
  final image3 = "/home/livio/Bureau/fadeplay_tests/img3.png";
  final image4 = "/home/livio/Bureau/fadeplay_tests/img4.png";
  final image5 = "/home/livio/Bureau/fadeplay_tests/img5.png";
  final image6 = "/home/livio/Bureau/fadeplay_tests/img6.png";

  @override
  Widget build(BuildContext context) {
    final artist1 = Artist(
      name: "Artist 1",
      originalName: "Original Artist 1",
      imageUri: Uri.file(image1),
    );
    final artist2 = Artist(
      name: "Artist 1",
      originalName: "Original Artist 1",
      imageUri: Uri.file(image2),
    );
    final artist3 = Artist(
      name: "Artist 1",
      originalName: "Original Artist 1",
      imageUri: Uri.file(image3),
    );
    final source = Source(
      title: "Source title",
      originalTitle: "Original Source title",
      imageUri: Uri.file(image4),
    );
    final album = Album(
      title: "Album title",
      originalTitle: "Original album title",
      imageUri: Uri.file(image5),
    );

    final Track track = Track(
      title: "Song title",
      originalTitle: "Original song title",
      artistString: "Song artists",
      fileUri: Uri.file(music),
      imageUri: Uri.file(image6),
      album: album,
      createdAt: DateTime.now(),
      diskNumber: PositionAndTotal(number: 1, totalNumber: 3),
      trackNumber: PositionAndTotal(number: 4, totalNumber: 28),
      releaseYear: 2025,
      rating: 6,
      startTime: Duration(seconds: 31),
      endTime: Duration(seconds: 90),
      moods: ["Mood 1", "Mood 2", "Mood 3"],
      instruments: ["Instrument 1", "Instrument 2", "Instrument 3"],
      artists: {
        artist1: ArtistRole.artist,
        artist2: ArtistRole.composer,
        artist3: ArtistRole.cover,
      },
      source: source,
      safety: Safety.safe,
      lyricsUri: null,
    );

    return Scaffold(
      body: Center(
        child: ColorSizeBox(
          color: Colors.grey,
          height: 500,
          width: 600,
          child: TrackInfoPage(track: track),
        ),
      ),
    );
  }
}
