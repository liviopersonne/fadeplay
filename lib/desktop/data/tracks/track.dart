import 'dart:io';

import 'package:fadeplay/desktop/data/has_id.dart';
import 'package:fadeplay/desktop/data/tracks/instrument.dart';
import 'package:fadeplay/desktop/data/tracks/mood.dart';
import 'package:fadeplay/desktop/data/tracks/safety.dart';
import 'package:fadeplay/desktop/db/schemas/enums.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/data/tracks/album.dart';
import 'package:fadeplay/desktop/data/tracks/artist.dart';
import 'package:fadeplay/desktop/data/tracks/audio_metadata.dart';
import 'package:fadeplay/desktop/data/tracks/source.dart';
import 'package:path/path.dart' as path;

final logger = Logging("Track");

/// A song and its metadata
class Track extends HasId {
  @override
  final int? id;
  final DateTime createdAt;
  String title;
  String? originalTitle;
  Map<Artist, ArtistRole> artists;
  String? artistString;
  Album? album;
  int? trackNumber;
  int? trackTotal;
  int? diskNumber;
  int? diskTotal;
  int? releaseYear;
  Uri fileUri;
  File file;
  Uri? imageUri;
  Uri? lyricsUri;
  late Duration duration;
  Duration? startTime;
  Duration? endTime;
  double? rating;
  List<Mood> moods;
  List<Instrument> instruments;
  Source? source;
  List<Safety> safeties;

  Track({
    this.id,
    DateTime? createdAt,
    required this.title,
    this.originalTitle,
    this.artists = const {},
    this.artistString,
    this.album,
    this.trackNumber,
    this.trackTotal,
    this.diskNumber,
    this.diskTotal,
    this.releaseYear,
    required this.fileUri,
    this.imageUri,
    this.lyricsUri,
    this.startTime,
    this.endTime,
    this.rating,
    this.moods = const [],
    this.instruments = const [],
    this.source,
    this.safeties = const [],
  }) : createdAt = createdAt ?? DateTime.now(),
       file = File.fromUri(fileUri) {
    if (MetadataReader.checkExtension(file)) {
      duration = MetadataReader.readFileLength(file)!;
    } else {
      logger.error(
        "Invalid extension used to initialize a track '${path.extension(fileUri.path)}'",
      );
      throw ArgumentError("Invalid file extension: ${fileUri.path}");
    }
  }

  bool checkValid() {
    final a = logger.check(
      duration.compareTo(Duration.zero) > 0,
      message: "Track duration must be strictly positive",
    );
    final b = logger.check(
      startTime == null || startTime!.compareTo(Duration.zero) >= 0,
      message: "Start time must be positive",
    );
    final c = logger.check(
      endTime == null || endTime!.compareTo(Duration.zero) >= 0,
      message: "End time must be positive",
    );
    final d = logger.check(
      startTime == null || startTime!.compareTo(duration) < 0,
      message: "Start time must be shorter than track duration",
    );
    final e = logger.check(
      endTime == null || endTime!.compareTo(duration) < 0,
      message: "End time must be shorter than track duration",
    );
    final f = logger.check(
      rating == null || (0 <= rating! && rating! <= 5),
      message: "Rating must be between 0 and 5",
    );

    return a && b && c && d && e && f;
  }

  @override
  bool operator ==(Object other) {
    if (other is Track) {
      return fileUri == other.fileUri;
    } else {
      return false;
    }
  }

  // TODO: Use the database id ??
  @override
  int get hashCode => fileUri.hashCode;

  @override
  String toString() {
    return 'Track<${id != null ? "id:$id" : "no id"}, $title>';
  }

  String detailedString() {
    return '''Track {
    id: $id,
    createdAt: $createdAt,
    title: $title,
    originalTitle: $originalTitle,
    artistString: $artistString,
    artists: $artists,
    album: $album,
    trackNumber: $trackNumber,
    trackTotal: $trackTotal,
    diskNumber: $diskNumber,
    diskTotal: $diskTotal,
    releaseYear: $releaseYear,
    fileUri: $fileUri,
    file: $file,
    imageUri: $imageUri,
    lyricsUri: $lyricsUri,
    duration: $duration,
    startTime: $startTime,
    endTime: $endTime,
    rating: $rating,
    moods: $moods,
    instruments: $instruments,
    source: $source,
    safeties: $safeties,
}''';
  }
}
