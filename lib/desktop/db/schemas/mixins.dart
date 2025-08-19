import 'package:drift/drift.dart';
import 'data_tables.dart';

mixin Id on Table {
  IntColumn get id => integer().autoIncrement()();
}

mixin DateAndId on Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get creationTime =>
      dateTime().withDefault(currentDateAndTime)();
}

mixin TrackId on Table {
  IntColumn get trackId => integer().references(
    Tracks,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
}
