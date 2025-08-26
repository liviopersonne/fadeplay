import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/objects/columns/item_column.dart';

class TitleColumn extends ItemColumn<Track> {
  @override
  String get id => "title";

  @override
  String get label => "Title";

  @override
  String getValue(Track item) => item.title;
}
