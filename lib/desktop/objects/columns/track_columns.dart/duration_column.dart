import 'package:fadeplay/desktop/objects/duration_formatter.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/objects/columns/item_column.dart';

class DurationColumn extends ItemColumn<Track> {
  @override
  String get id => "duration";

  @override
  String get label => "Duration";

  @override
  String getValue(Track item) => DurationFormatter.mss(item.duration);

  @override
  int compare(Track item1, Track item2) {
    return item1.duration.compareTo(item2.duration);
  }
}
