import 'package:logger/logger.dart';

class Logging {
  final String scope;
  static final Logger _simpleLogger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      noBoxingByDefault: true,
      colors: true,
    ),
    level: Level.all,
  );
  static final Logger _fullLogger = Logger(
    printer: PrettyPrinter(),
    level: Level.all,
  );

  Logging(this.scope);

  String scopedMessage(String message) => "[$scope] $message";

  void debug(String message) {
    _simpleLogger.d(scopedMessage(message));
  }

  void log(String message) {
    _simpleLogger.i(scopedMessage(message));
  }

  void warn(String message) {
    _fullLogger.w(" $scopedMessage(message)");
  }

  void error(String message, {String? errorName}) {
    _fullLogger.e(scopedMessage(message), error: errorName);
  }
}
