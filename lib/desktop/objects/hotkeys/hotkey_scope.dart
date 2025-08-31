import 'package:flutter/material.dart';

class HotkeyScope {
  HotkeyScope({required this.id, required this.shortcuts});

  final String id;
  final Map<ShortcutActivator, Intent> shortcuts;
}
