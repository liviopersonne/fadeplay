// TODO: Keep registry of each column

// NOTE: `T` is usually `Track`

abstract class ItemColumn<T> {
  /// Unique identifier
  String get id;

  /// Column header
  String get label;

  /// Tthe value to be shown in the column for a specific item
  String getValue(T item);

  /// Checks if a value is less or equal than another.
  /// - item1 < item2 => leq < 0
  /// - item1 = item2 => leq = 0
  /// - item1 > item2 => leq > 0
  int compare(T item1, T item2) => getValue(item1).compareTo(getValue(item2));

  @override
  bool operator ==(Object other) {
    if (other is ItemColumn<T>) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => "${T.toString()}ItemColumn<id: $id>";
}
