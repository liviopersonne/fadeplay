import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
// import 'package:path_provider/path_provider.dart';
import 'schemas/data_tables.dart';
import 'schemas/enum_tables.dart';
import 'schemas/relation_tables.dart';
import 'schemas/enums.dart';

part 'schemas.g.dart';

// Database generate
@DriftDatabase(
  tables: [
    Tracks,
    Artists,
    Albums,
    Sources,
    Playlists,
    Transitions,
    Moods,
    Instruments,
    Languages,
    TrackMoods,
    TrackInstruments,
    TrackSolos,
    TrackLanguages,
    TrackArtists,
    TrackSafeties,
    PlaylistTracks,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'fadeplay',
      native: DriftNativeOptions(
        // NOTE: For a private database in ~/.local/share/<appName> | .../data/data/<package>/files
        // databaseDirectory: getApplicationSupportDirectory,

        // NOTE: For a public database in ~/Documents | .../data/data/<package>/app_flutter
        // databaseDirectory: getApplicationDocumentsDirectory,

        // NOTE: For perfect control of the db path
        databasePath: () async {
          final dir = Directory('lib/desktop/db');
          await dir.create(recursive: true);
          return '${dir.path}/fadeplay.sqlite';
        },
      ),
      // TODO: Set this up correctly
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
