import 'package:fadeplay/desktop/data/has_id.dart';

/// An album and its metadata
class Album extends HasId {
  @override
  int? id;
  String title;
  String? originalTitle;
  Uri? imageUri;

  Album({this.id, required this.title, this.originalTitle, this.imageUri});

  @override
  String toString() {
    return 'Album<${id != null ? "id:$id" : "no id"}, $title>';
  }
}
