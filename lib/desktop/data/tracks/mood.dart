import 'package:fadeplay/desktop/data/has_id.dart';

class Mood extends HasId {
  @override
  final int? id;
  final String mood;

  Mood({this.id, required this.mood});

  @override
  String toString() {
    return 'Mood<${id != null ? "id:$id" : "no id"}, $mood>';
  }
}
