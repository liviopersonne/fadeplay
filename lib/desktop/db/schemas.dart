import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
// import 'package:path_provider/path_provider.dart';
import 'schemas/data_tables.dart';
import 'schemas/enum_tables.dart';
import 'schemas/relation_tables.dart';
import 'schemas/enums.dart';
import 'schemas/checks.dart';

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

  // Database seed
  Future<void> seedMoods() async {
    for (String mood in moodElems) {
      await into(moods).insert(MoodsCompanion.insert(label: mood.toString()));
    }
  }

  Future<void> seedInstruments() async {
    for (String instrument in instrumentElems) {
      await into(
        instruments,
      ).insert(InstrumentsCompanion.insert(label: instrument.toString()));
    }
  }

  Future<void> seedLanguages() async {
    for (String language in languageElems) {
      await into(
        languages,
      ).insert(LanguagesCompanion.insert(label: language.toString()));
    }
  }

  // Database generator
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        if (details.wasCreated) {
          // Seeding the database
          await seedMoods();
          await seedInstruments();
          await seedLanguages();
        }
        // This is to enable foreign keys in sqlite3, so that we can delete cascade
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

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
