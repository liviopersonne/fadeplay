import 'package:fadeplay/desktop/db/schemas/enums.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/data/tracks/track.dart';
import 'package:fadeplay/desktop/settings/settings.dart';

final logger = Logging("Transition");

class Transition {
  final DateTime createdAt;
  final Track track1;
  final Track track2;
  Duration fadeoutEnd;
  Duration fadeinStart;
  Duration fadeoutDuration;
  Duration fadeinDuration;
  Duration delay;
  String? comment;
  final TransitionType type;

  Transition({
    DateTime? createdAt,
    required this.track1,
    required this.track2,
    Duration? fadeoutEnd,
    Duration? fadeinStart,
    Duration? fadeoutDuration,
    Duration? fadeinDuration,
    Duration? delay,
    this.comment,
    required this.type,
  }) : createdAt = createdAt ?? DateTime.now(),
       fadeoutEnd = fadeoutEnd ?? track1.duration,
       fadeinStart = fadeinStart ?? Duration.zero,
       fadeoutDuration = fadeoutDuration ?? Settings.defaultcrossfadeDuration,
       fadeinDuration = fadeinDuration ?? Settings.defaultcrossfadeDuration,
       delay = delay ?? Duration.zero;

  bool checkValid() {
    final a = logger.check(
      fadeoutEnd.compareTo(Duration.zero) > 0,
      message: "Fadeout end time must be strictly positive",
    );
    final b = logger.check(
      fadeoutEnd.compareTo(track1.duration) <= 0,
      message: "Fadeout end time must be before the end of the track",
    );
    final c = logger.check(
      fadeinStart.compareTo(Duration.zero) >= 0,
      message: "Fadein start time must be positive",
    );
    final d = logger.check(
      fadeinStart.compareTo(track1.duration) < 0,
      message: "Fadein start time must be strictly before the end of the track",
    );
    final e = logger.check(
      fadeoutDuration.compareTo(Duration.zero) >= 0,
      message: "Fadeout duration must be positive",
    );
    final f = logger.check(
      fadeinDuration.compareTo(Duration.zero) >= 0,
      message: "Fadein duration must be positive",
    );

    return a && b && c && d && e && f;
  }
}
