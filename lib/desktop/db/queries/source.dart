import 'package:drift/drift.dart';
import 'package:fadeplay/desktop/data/tracks/source.dart' as obj;
import 'package:fadeplay/desktop/db/schemas.dart' as db;
import 'package:fadeplay/desktop/objects/logger.dart';

final logger = Logging("getSources");

Future<List<obj.Source>> getSources({String? name}) async {
  final database = db.AppDatabase();

  final allSources = await database
      .select(database.sources)
      //.orderBy()
      .get();

  return allSources
      .map(
        (s) => obj.Source(
          title: s.title,
          originalTitle: s.originalTitle,
          imageUri: s.imagePath != null ? Uri.parse(s.imagePath!) : null,
        ),
      )
      .toList();
}

Future<void> upsertSource({required obj.Source source}) async {
  final database = db.AppDatabase();

  await database
      .into(database.sources)
      .insert(
        db.SourcesCompanion.insert(
          title: source.title,
          originalTitle: Value(source.originalTitle),
          imagePath: Value(source.imageUri?.toString()),
        ),
      );
}
