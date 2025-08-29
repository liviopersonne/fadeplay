import 'dart:convert';
import 'dart:ui';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fadeplay/desktop/objects/logger.dart';

final logger = Logging("WindowManager");

/// All information needed to interact with a window
/// - `id`: id of the window: a number
/// - `name` name of the window
/// - `controller` the `WindowController` used to interact with the window
class WindowInfo {
  WindowInfo({
    required this.idName,
    required this.controller,
    required this.title,
  });

  final WindowController controller;
  final String idName;
  final String title;
  bool isOpen = false;
}

/// The manager used to create and interact with all existing windows
class WindowManager {
  WindowManager._();

  /// Maps all window idNames to their info
  static final Map<String, WindowInfo> _windows = {};

  static Future<void> createWindow({
    required String idName,
    required String title,
    Offset offset = const Offset(100, 100),
    Size size = const Size(800, 600),
    bool resizable = true,
  }) async {
    if (_windows.keys.contains(idName)) {
      logger.error("Tried to create a window with existing idName '$idName'");
      return;
    }

    final windowController = await DesktopMultiWindow.createWindow(
      jsonEncode({}), // no arguments passed to the screen
    );
    windowController
      ..setFrame(offset & size)
      ..setTitle(title);

    _windows.addAll({
      idName: WindowInfo(
        idName: idName,
        title: title,
        controller: windowController,
      ),
    });
  }

  static Future<void> showWindow({required String idName}) async {
    if (!_windows.keys.contains(idName)) {
      logger.error("Tried to show a window that disn't exist '$idName'");
      return;
    }

    final windowInfo = _windows[idName]!;

    if (windowInfo.isOpen) {
      logger.warn("Tried showing already opened window '$idName'");
    }
    windowInfo.controller.show();
    windowInfo.isOpen = true;
  }

  static Future<void> hideWindow({required String idName}) async {
    if (!_windows.keys.contains(idName)) {
      logger.error("Tried to hide a window that disn't exist '$idName'");
      return;
    }

    final windowInfo = _windows[idName]!;

    if (!windowInfo.isOpen) {
      logger.warn("Tried hiding window '$idName' which wasn't open");
    }
    windowInfo.controller.hide();
    windowInfo.isOpen = false;
  }
}
