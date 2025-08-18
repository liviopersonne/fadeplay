class Settings {
  Settings._();

  static double playerVolume = 1.0;

  static Duration crossfadeDuration = Duration(seconds: 1);

  /// Save settings
  static void saveSettings() {
    throw UnimplementedError("Haven't implemented saving settings yet");
  }

  /// Load settings
  static void loadSettings() {
    throw UnimplementedError("Haven't implemented loading settings yet");
  }
}
