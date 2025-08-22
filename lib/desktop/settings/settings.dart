class Settings {
  Settings._();

  /// The current volume of the player
  static double playerVolume = 1.0;

  /// The default duration of crossfades
  /// This will be used by the player but also by the custom transition creator
  static Duration defaultcrossfadeDuration = const Duration(seconds: 1);

  /// The best precision of transitions:
  /// the position in the music will be seeked at most at this frequency
  static Duration bestTransitionPrecision = const Duration(milliseconds: 50);

  /// The worst precision of transitions:
  /// transitions won't be offset by more than this value
  static Duration worstTransitionPrecision = const Duration(milliseconds: 50);

  /// Save settings
  static void saveSettings() {
    throw UnimplementedError("Haven't implemented saving settings yet");
  }

  /// Load settings
  static void loadSettings() {
    throw UnimplementedError("Haven't implemented loading settings yet");
  }
}
