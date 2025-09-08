import 'package:fadeplay/desktop/data/has_id.dart';

class Safety extends HasId {
  @override
  final int? id;
  final String safety;

  Safety({this.id, required this.safety});
}
