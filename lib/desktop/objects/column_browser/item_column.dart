import 'package:fadeplay/desktop/data/tracks/track.dart';

import '../../data/track_columns/_all.dart';

// NOTE: `T` is usually `Track`

import 'package:fadeplay/desktop/objects/logger.dart';

final logger = Logging("ItemColumn");

mixin BigColumn {
  double get defaultWidth => 100;
  double get minWidth => 50;
}

mixin MediumColumn {
  double get defaultWidth => 50;
  double get minWidth => 30;
}

mixin SmallColumn {
  double get defaultWidth => 10;
  double get minWidth => 10;
}

abstract class ItemColumn {
  /// An internal registry of all columns
  static final Map<String, ItemColumn> _columnsRegistry = {};

  /// A map access to all columns (not externally modifiable)
  static Map<String, ItemColumn> get allColumns =>
      Map.unmodifiable(_columnsRegistry);

  /// Registers the created column in the global registry
  ItemColumn() {
    if (_columnsRegistry.containsKey(id)) {
      logger.error("Duplicate ids '$id' for ItemColumn");
    } else {
      _columnsRegistry.addAll({id: this});
    }
  }

  /// Unique identifier
  String get id;

  /// Column header
  String get label;

  /// Default width
  double get defaultWidth;

  /// Minimum width
  double get minWidth;

  /// Tthe value to be shown in the column for a specific item
  String getValue(Track item);

  /// Checks if a value is less or equal than another.
  /// - item1 < item2 => leq < 0
  /// - item1 = item2 => leq = 0
  /// - item1 > item2 => leq > 0
  int compare(Track item1, Track item2) =>
      getValue(item1).compareTo(getValue(item2));

  @override
  bool operator ==(Object other) {
    if (other is ItemColumn) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => "ItemColumn<id: $id>";
}

void registerAllColumns() {
  ArtistColumn.instance;
  DurationColumn.instance;
  TitleColumn.instance;

  // TODO: Keep this updated with new columns

  logger.debug("Registered all columns: ${ItemColumn.allColumns.keys}");
}
