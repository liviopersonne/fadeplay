import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/objects/columns/item_column.dart';

class ArtistColumn extends ItemColumn<Track> {
  @override
  String get id => "artist";

  @override
  String get label => "Artist";

  @override
  String getValue(Track item) => item.artistString ?? "";
}
