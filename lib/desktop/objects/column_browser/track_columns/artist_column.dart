import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';

class ArtistColumn extends ItemColumn with BigColumn {
  // Singleton definition
  ArtistColumn._() : super();
  static final ArtistColumn instance = ArtistColumn._();

  @override
  String get id => "artist";

  @override
  String get label => "Artist";

  @override
  String getValue(Track item) => item.artistString ?? "";
}
