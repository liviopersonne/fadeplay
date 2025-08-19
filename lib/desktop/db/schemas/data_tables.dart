import 'package:drift/drift.dart';
import 'mixins.dart';
import 'enums.dart';
import 'checks.dart';

class Tracks extends Table with DateAndId {
  TextColumn get title => text()();
  TextColumn get artistString => text()();
  late final IntColumn trackNumber = integer().nullable().check(
    validTrackDiskNumbers(trackNumber, diskNumber),
  )();
  late final IntColumn diskNumber = integer().nullable().check(
    validTrackDiskNumbers(trackNumber, diskNumber),
  )();
  late final IntColumn duration = integer().check(
    duration.isBiggerThanValue(0),
  )();
  late final IntColumn year = integer().check(positiveOrNull(year))();
  late final IntColumn startTime = integer().nullable().check(
    clipTimeCondition(startTime, duration),
  )();
  late final IntColumn endTime = integer().nullable().check(
    clipTimeCondition(endTime, duration),
  )();
  late final RealColumn rating = real().nullable().check(
    ratingCondition(rating),
  )();
  IntColumn get albumId => integer().nullable().references(Albums, #id)();
  IntColumn get sourceId => integer().nullable().references(Sources, #id)();
  TextColumn get imagePath => text().nullable()();
  TextColumn get lyricsPath => text().nullable()();
}

class Artists extends Table with Id {
  TextColumn get name => text()();
  TextColumn get originalName => text()();
  TextColumn get imagePath => text()();
}

class Albums extends Table with Id {
  TextColumn get title => text()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get imagePath => text().nullable()();
}

class Sources extends Table with Id {
  TextColumn get title => text()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get imagePath => text().nullable()();
}

class Playlists extends Table with Id {
  TextColumn get name => text()();
  TextColumn get imagePath => text()();
}

class Transitions extends Table with DateAndId {
  @ReferenceName("track1Transitions")
  IntColumn get trackId1 => integer().references(Tracks, #id)();
  @ReferenceName("track2Transitions")
  IntColumn get trackId2 => integer().references(Tracks, #id)();
  late final IntColumn fadeoutEnd = integer().check(
    fadeoutEnd.isBiggerOrEqualValue(0),
  )();
  late final IntColumn fadeoutduration = integer().check(
    fadeoutduration.isBiggerOrEqualValue(0),
  )();
  late final IntColumn fadeinStart = integer().check(
    fadeinStart.isBiggerOrEqualValue(0),
  )();
  late final IntColumn fadeinduration = integer().check(
    fadeinduration.isBiggerOrEqualValue(0),
  )();
  RealColumn get delay => real().withDefault(const Constant(0.0))();
  TextColumn get comment => text().nullable()();
  IntColumn get type => intEnum<TransitionType>()();
}
