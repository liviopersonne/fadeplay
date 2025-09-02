import 'dart:async';

import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/track_info/tag_editor.dart';
import 'package:flutter/material.dart';

class SubtagEditor extends StatefulWidget {
  const SubtagEditor({
    super.key,
    required this.label,
    required this.subtagLabel,
    this.textFieldWidth = 400,
    this.controller,
  });

  final String label;
  final String subtagLabel;
  final double textFieldWidth;
  final TextEditingController? controller;
  @override
  State<SubtagEditor> createState() => _SubtagEditorState();
}

class _SubtagEditorState extends State<SubtagEditor>
    with SingleTickerProviderStateMixin {
  late Animation<double> _boxHeight;
  late Animation<double> _paddingHeight;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _boxHeight =
        Tween<double>(begin: 0, end: 37).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeOutCirc),
        )..addListener(() {
          setState(() {});
        });
    _paddingHeight =
        Tween<double>(begin: 0, end: MyTheme.paddingTiny).animate(controller)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TagEditor(label: widget.label),

        Offstage(
          offstage: _boxHeight.value == 0,
          child: Padding(
            padding: EdgeInsets.only(top: MyTheme.paddingTiny),
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(
                Size.fromHeight(_boxHeight.value),
              ),
              child: TagEditor(label: widget.subtagLabel),
            ),
          ),
        ),
        SizedBox(height: _paddingHeight.value),
      ],
    );
  }
}
