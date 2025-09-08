import 'package:fadeplay/desktop/data/has_id.dart';

/// An source and its metadata.
/// A source is a piece of media (film, video game) which has an ost.
class Source extends HasId {
  @override
  int? id;
  String title;
  String? originalTitle;
  Uri? imageUri;

  Source({this.id, required this.title, this.originalTitle, this.imageUri});

  @override
  String toString() {
    return "Source<$title${originalTitle == null ? "" : "($originalTitle)"}, ${imageUri == null ? 'noImg' : 'Img'}>";
  }
}
