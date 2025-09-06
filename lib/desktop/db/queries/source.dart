import 'package:drift/drift.dart';
import 'package:fadeplay/desktop/data/tracks/source.dart' as obj;
import 'package:fadeplay/desktop/db/schemas.dart' as db;
import 'package:fadeplay/desktop/objects/logger.dart';

final logger = Logging("getSources");

Future<List<obj.Source>> getSources({
  List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
  Expression<bool> Function(db.$SourcesTable u)? filter,
}) async {
  final database = db.AppDatabase();

  final query = database.select(database.sources);

  if (filter != null) {
    query.where(filter);
  }

  if (orderBy != null) {
    query.orderBy(orderBy);
  }

  final allSources = await query.get();

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
