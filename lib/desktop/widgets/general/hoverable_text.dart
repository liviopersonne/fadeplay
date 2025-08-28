import 'package:flutter/material.dart';

class HoverableText extends StatefulWidget {
  const HoverableText({
    super.key,
    required this.text,
    this.backgroundActive,
    this.backgroundInactive,
    this.styleActive,
    this.styleInactive,
    this.hoveringCursor = MouseCursor.defer,
  });

  final String text;
  final Color? backgroundActive;
  final Color? backgroundInactive;
  final TextStyle? styleActive;
  final TextStyle? styleInactive;
  final MouseCursor hoveringCursor;

  @override
  State<HoverableText> createState() => _HoverableTextState();
}

class _HoverableTextState extends State<HoverableText> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.hoveringCursor,
      onEnter: (event) {
        setState(() {
          hovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          hovering = false;
        });
      },
      child: hovering
          ? Container(
              color: widget.backgroundActive,
              child: Text(widget.text, style: widget.styleActive),
            )
          : Container(
              color: widget.backgroundInactive,
              child: Text(widget.text, style: widget.styleInactive),
            ),
    );
  }
}
