import 'package:flutter/material.dart';

// Check out info about hotkeys at docs/hotkeys.md

///
class HotkeyScope extends StatelessWidget {
  const HotkeyScope({
    super.key,
    required this.id,
    required this.focusNode,
    this.autofocus = false,
    required this.child,
  });

  final String id;
  final FocusNode focusNode;
  final bool autofocus;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


// TODO: Make some sort of manager