import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';

final logger = Logging("TestKeyboardListener");

class TestKeyboardListener extends StatefulWidget {
  const TestKeyboardListener({super.key});

  @override
  State<TestKeyboardListener> createState() => _TestKeyboardListenerState();
}

class _TestKeyboardListenerState extends State<TestKeyboardListener> {
  String content = "Hello";
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeyboardListener(
              focusNode: _focusNode,
              // autofocus: true,
              autofocus: false,
              onKeyEvent: (value) {
                setState(() => content = value.toString());
              },
              child: GestureDetector(
                onTap: () => setState(() {
                  // _focusNode.requestFocus();
                  FocusScope.of(context).requestFocus(_focusNode);
                }),
                child: ColorSizeBox(
                  height: 300,
                  width: 300,
                  color: _focusNode.hasFocus ? Colors.teal : Colors.grey,
                  child: Center(child: Text(content)),
                ),
              ),
            ),
            MyButton(
              text: "Unfocus",
              width: 200,
              onTap: () => setState(() {
                // _focusNode.unfocus();
                FocusScope.of(context).unfocus();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
