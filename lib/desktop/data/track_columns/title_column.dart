import 'package:fadeplay/desktop/data/tracks/track.dart';
import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';

class TitleColumn extends ItemColumn with BigColumn {
  // Singleton definition
  TitleColumn._() : super();
  static final TitleColumn instance = TitleColumn._();

  @override
  String get id => "title";

  @override
  String get label => "Title";

  @override
  String getValue(Track item) => item.title;
}
