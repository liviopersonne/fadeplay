import 'package:fadeplay/desktop/db/schemas/enums.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/tracks/album.dart';
import 'package:fadeplay/desktop/objects/tracks/artist.dart';
import 'package:fadeplay/desktop/objects/tracks/source.dart';

final logger = Logging("Track");

/// A song and its metadata
class Track {
  final DateTime createdAt;
  String title;
  String? originalTitle;
  Map<Artist, ArtistRole> artists;
  Album? album;
  PositionAndTotal? trackNumber;
  PositionAndTotal? diskNumber;
  int? releaseYear;
  Uri fileUri;
  Uri? imageUri;
  Uri? lyricsUri;
  final Duration duration;
  Duration? startTime;
  Duration? endTime;
  int? rating;
  List<String> moods;
  List<String> instruments;
  Source? source;
  Safety? safety;

  Track({
    DateTime? createdAt,
    required this.title,
    this.originalTitle,
    this.artists = const {},
    this.album,
    this.trackNumber,
    this.diskNumber,
    this.releaseYear,
    required this.fileUri,
    this.imageUri,
    this.lyricsUri,
    required this.duration,
    this.startTime,
    this.endTime,
    this.rating,
    this.moods = const [],
    this.instruments = const [],
    this.source,
    this.safety,
  }) : createdAt = createdAt ?? DateTime.now();

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
      rating == null || (0 <= rating! && rating! <= 10),
      message: "Rating must be between 0 and 10",
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
}

/// Helper class that implements position and total number of objects
class PositionAndTotal {
  int number;
  int totalNumber;

  PositionAndTotal({required this.number, required this.totalNumber});
}
