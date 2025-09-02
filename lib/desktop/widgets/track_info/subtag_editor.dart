import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/track_info/tag_editor.dart';
import 'package:flutter/material.dart';

class SubtagEditor extends StatefulWidget {
  const SubtagEditor({
    super.key,
    required this.label,
    required this.subtagLabel,
    this.textFieldWidth = 400,
    this.textController,
    this.subTextController,
  });

  final String label;
  final String subtagLabel;
  final double textFieldWidth;
  final TextEditingController? textController;
  final TextEditingController? subTextController;
  @override
  State<SubtagEditor> createState() => _SubtagEditorState();
}

class _SubtagEditorState extends State<SubtagEditor>
    with SingleTickerProviderStateMixin {
  late Animation<double> _boxHeight;
  late Animation<double> _paddingHeight;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _boxHeight =
        Tween<double>(begin: 0, end: 37).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOutCirc),
        )..addListener(() {
          setState(() {});
        });
    _paddingHeight =
        Tween<double>(
          begin: 0,
          end: MyTheme.paddingTiny,
        ).animate(_animController)..addListener(() {
          setState(() {});
        });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TagEditor(
          label: widget.label,
          textFieldWidth: widget.textFieldWidth,
          controller: widget.textController,
          openDetails: () => _animController.toggle(),
        ),

        Offstage(
          offstage: _boxHeight.value == 0,
          child: Padding(
            padding: EdgeInsets.only(top: MyTheme.paddingTiny),
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(
                Size.fromHeight(_boxHeight.value),
              ),
              child: TagEditor(
                label: widget.subtagLabel,
                controller: widget.subTextController,
                textFieldWidth: widget.textFieldWidth,
              ),
            ),
          ),
        ),
        SizedBox(height: _paddingHeight.value),
      ],
    );
  }
}
