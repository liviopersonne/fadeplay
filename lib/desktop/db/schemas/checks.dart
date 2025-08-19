import 'package:drift/drift.dart';

Expression<bool> positiveOrNull(Column<int> number) =>
    (number.isNull() | number.isBiggerThanValue(0));

Expression<bool> validTrackDiskNumbers(Column<int> track, Column<int> disk) =>
    (track.isNull() & disk.isNull()) |
    (track.isBiggerThanValue(0) & disk.isNull()) |
    (track.isBiggerThanValue(0) & disk.isBiggerThanValue(0));

Expression<bool> clipTimeCondition(Column<int> clip, Column<int> total) =>
    (clip.isNull() | clip.isBetween(const Constant(0), total));

Expression<bool> ratingCondition(Column<double> rating) =>
    rating.isIn([0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]);
