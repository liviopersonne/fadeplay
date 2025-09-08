import 'package:fadeplay/desktop/data/has_id.dart';

/// An artist and its metadata
class Artist extends HasId {
  @override
  int? id;
  String name;
  String? originalName;
  Uri? imageUri;

  Artist({this.id, required this.name, this.originalName, this.imageUri});
}
