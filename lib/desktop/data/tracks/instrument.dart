import 'package:fadeplay/desktop/data/has_id.dart';

class Instrument extends HasId {
  @override
  final int? id;
  final String instrument;

  Instrument({this.id, required this.instrument});

  @override
  String toString() {
    return 'Instrument<${id != null ? "id:$id" : "no id"}, $instrument>';
  }
}
