import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final logger = Logging("TestHotkeys");

class TestHotkeys extends StatefulWidget {
  const TestHotkeys({super.key});

  @override
  State<TestHotkeys> createState() => _TestHotkeysState();
}

class _TestHotkeysState extends State<TestHotkeys> {
  final _focusNodes = List.generate(3, (_) => FocusNode());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Shortcuts(
          shortcuts: {
            SingleActivator(LogicalKeyboardKey.keyC, control: true):
                CopyIntent(),
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (i) => Actions(
                actions: {CopyIntent: CopyAction(i: i)},

                child: Focus(
                  autofocus: true,
                  focusNode: _focusNodes[i],
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        FocusScope.of(context).requestFocus(_focusNodes[i]);
                      });
                    },
                    child: ColorSizeBox(
                      color: _focusNodes[i].hasFocus
                          ? Colors.amber
                          : Colors.grey,
                      height: 300,
                      width: 200,
                      child: Center(
                        child: Text(
                          _focusNodes[i].hasFocus ? "Focused" : "Unfocused",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CopyIntent extends Intent {}

class CopyAction extends Action<CopyIntent> {
  CopyAction({required this.i});

  final int i;

  @override
  Object? invoke(CopyIntent intent) {
    logger.log("$i pressed ctrl + c");

    return null;
  }
}
