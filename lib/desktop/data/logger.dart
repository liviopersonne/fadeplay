import 'package:logging/logging.dart';

class Logging {
  final String scope;
  final Logger _innerLogger;

  Logging(this.scope) : _innerLogger = Logger(scope);

  String scopedMessage(String message) => "[Fadeplay | $scope] $message";

  void log(String message) {
    _innerLogger.log(Level.INFO, scopedMessage(message));
  }

  void warn(String message) {
    _innerLogger.log(Level.WARNING, scopedMessage(message));
  }
}
