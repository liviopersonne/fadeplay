/// Helper class to format `Duration` objects
class DurationFormatter {
  DurationFormatter._();

  /// Format to hh:mm:ss
  ///
  /// If the duration is more than 100 hours, it will show `100:00:00` etc...
  static String hhmmss(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  /// Format to mm:ss
  ///
  /// If the duration is less than 10 minutes, it will show `09:59`
  ///
  /// If the duration is more than 1 hour, it will show `60:00` etc...
  static String mmss(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inMinutes)}:$twoDigitSeconds";
  }

  /// Format to mm:ss
  ///
  /// If the duration is less than 10 minutes, it will show `9:59`
  ///
  /// If the duration is more than 1 hour, it will show `60:00` etc...
  static String mss(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${duration.inMinutes}:$twoDigitSeconds";
  }
}
