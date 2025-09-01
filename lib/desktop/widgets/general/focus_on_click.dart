import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final logger = Logging("FocusOnClick");

/// A widget that gets focused than you click on it.
///
/// You can pass a `focusNode` if you want to allow
/// other widgets to  focus or unfocus this.
///
/// You can also pass some callbacks for the `gestureDetector`
class FocusOnClick extends StatefulWidget {
  const FocusOnClick({
    super.key,
    required this.builder,
    this.focusNode,
    this.autofocus = false,
    this.onTap,
    this.onSecondaryTap,
    this.onTapDown,
    this.onSecondaryTapDown,
    this.onDoubleTap,
  });

  final Widget Function(bool focused) builder;
  final FocusNode? focusNode;
  final bool autofocus;
  final void Function()? onTap;
  final void Function()? onSecondaryTap;
  final void Function(TapDownDetails details)? onTapDown;
  final void Function(TapDownDetails details)? onSecondaryTapDown;
  final void Function()? onDoubleTap;

  @override
  State<FocusOnClick> createState() => _FocusOnClickState();
}

class _FocusOnClickState extends State<FocusOnClick> {
  FocusNode? _localFocusNode;
  late final SerialTapGestureRecognizer _primaryTapRecognizer;
  late final TapGestureRecognizer _secondaryTapRecognizer;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _localFocusNode = FocusNode();
    }
    _primaryTapRecognizer =
        SerialTapGestureRecognizer(
            allowedButtonsFilter: (buttons) => buttons & kPrimaryButton != 0,
          )
          ..onSerialTapUp = (details) {
            if (details.count == 1) {
              widget.onTap?.call();
            } else if (details.count == 2) {
              widget.onDoubleTap?.call();
            }
          };
    _secondaryTapRecognizer =
        TapGestureRecognizer(
            allowedButtonsFilter: (buttons) => buttons & kSecondaryButton != 0,
          )
          ..onTap = widget.onSecondaryTap
          ..onTapDown = (details) => widget.onSecondaryTapDown?.call(details);
  }

  @override
  void dispose() {
    _localFocusNode?.dispose();
    _localFocusNode = null;
    _primaryTapRecognizer.dispose();
    _secondaryTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode realFocusNode = widget.focusNode ?? _localFocusNode!;

    return Focus(
      autofocus: widget.autofocus,
      focusNode: realFocusNode,
      onFocusChange: (_) => setState(() => ()),
      child: RawGestureDetector(
        gestures: {
          SerialTapGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<SerialTapGestureRecognizer>(
                () => _primaryTapRecognizer,
                (instance) {
                  instance.onSerialTapDown = (details) {
                    if (details.count == 1) {
                      FocusScope.of(context).requestFocus(realFocusNode);
                      widget.onTapDown?.call(
                        TapDownDetails(
                          globalPosition: details.globalPosition,
                          localPosition: details.localPosition,
                          kind: details.kind,
                        ),
                      );
                    }
                  };
                },
              ),
          TapGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                () => _secondaryTapRecognizer,
                (instance) {},
              ),
        },

        child: widget.builder(realFocusNode.hasFocus),
      ),
    );
  }
}
