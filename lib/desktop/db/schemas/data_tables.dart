import 'package:drift/drift.dart';
import 'mixins.dart';
import 'enums.dart';

// FIXME: Fix recursive getters on checks (I've commented them out for now)

class Tracks extends Table with DateAndId {
  TextColumn get title => text()();
  TextColumn get artistString => text()();
  // IntColumn get trackNumber => integer().nullable().check(
  //   validTrackDiskNumbers(trackNumber, diskNumber),
  // )();
  IntColumn get trackNumber => integer().nullable()();
  // IntColumn get diskNumber => integer().nullable().check(
  //   validTrackDiskNumbers(trackNumber, diskNumber),
  // )();
  IntColumn get diskNumber => integer().nullable()();
  // IntColumn get duration => integer().check(duration.isBiggerThanValue(0))();
  IntColumn get duration => integer()();
  // IntColumn get year => integer().check(positiveOrNull(year))();
  IntColumn get year => integer()();
  // IntColumn get startTime =>
  //     integer().nullable().check(clipTimeCondition(startTime, duration))();
  IntColumn get startTime => integer().nullable()();
  // IntColumn get endTime =>
  //     integer().nullable().check(clipTimeCondition(endTime, duration))();
  IntColumn get endTime => integer().nullable()();
  // RealColumn get rating => real().nullable().check(ratingCondition(rating))();
  RealColumn get rating => real().nullable()();
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
  // IntColumn get fadeoutEnd =>
  //     integer().check(fadeoutEnd.isBiggerOrEqualValue(0))();
  IntColumn get fadeoutEnd => integer()();
  // IntColumn get fadeoutduration =>
  //     integer().check(fadeoutduration.isBiggerOrEqualValue(0))();
  IntColumn get fadeoutduration => integer()();
  // IntColumn get fadeinStart =>
  //     integer().check(fadeinStart.isBiggerOrEqualValue(0))();
  IntColumn get fadeinStart => integer()();
  // IntColumn get fadeinduration =>
  //     integer().check(fadeinduration.isBiggerOrEqualValue(0))();
  IntColumn get fadeinduration => integer()();
  RealColumn get delay => real().withDefault(const Constant(0.0))();
  TextColumn get comment => text().nullable()();
  IntColumn get type => intEnum<TransitionType>()();
}
