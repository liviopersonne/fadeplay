import 'package:drift/drift.dart';
import 'package:fadeplay/desktop/data/tracks/source.dart' as obj;
import 'package:fadeplay/desktop/db/schemas.dart' as db;
import 'package:fadeplay/desktop/objects/logger.dart';

part 'source.dart';

final logger = Logging("DbQuery");

/// A class that wraps all queries made to the database
class DbQuery {
  DbQuery._();

  static Future<List<obj.Source>> getSources({
    List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
    Expression<bool> Function(db.$SourcesTable u)? filter,
  }) => _getSources(orderBy: orderBy, filter: filter);

  static Future<void> upsertSource({required obj.Source source}) =>
      _upsertSource(source: source);
}
