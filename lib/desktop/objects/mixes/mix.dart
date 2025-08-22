import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/mixes/transition.dart';

final logger = Logging("Mix");

class Mix {
  final DateTime createdAt;
  String title;
  List<Transition> transitions;

  Mix({DateTime? createdAt, required this.title, required this.transitions})
    : createdAt = createdAt ?? DateTime.now();

  bool checkValid() {
    bool valid = true;

    for (var i = 0; i < transitions.length - 1; i++) {
      final transition1 = transitions[i];
      final transition2 = transitions[i + 1];
      final test = logger.check(
        transition1.track2 == transition2.track1,
        message: "Mismatching transitions $i and ${i + 1}",
      );
      valid = valid && test;
    }

    return valid;
  }
}
