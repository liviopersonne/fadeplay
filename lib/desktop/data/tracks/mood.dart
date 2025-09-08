import 'package:fadeplay/desktop/data/has_id.dart';

class Mood extends HasId {
  @override
  final int? id;
  final String mood;

  Mood({this.id, required this.mood});
}
