part of 'queries.dart';

Future<List<obj.Source>> _getSources({
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

Future<void> _upsertSource({required obj.Source source}) async {
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
