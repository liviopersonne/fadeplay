import 'package:fadeplay/desktop/data/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:media_kit/media_kit.dart';
import 'package:just_audio/just_audio.dart';

final logger = Logging("AudioPlayer");

class MusicPlayer {
  static var _initialized = false;
  final _player = AudioPlayer();

  static void initialize() {
    logger.log("Initializing Audio Player...");
    switch (defaultTargetPlatform) {
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        JustAudioMediaKit.ensureInitialized();
        JustAudioMediaKit.mpvLogLevel = MPVLogLevel.debug;
        JustAudioMediaKit.bufferSize = 8 * 1024 * 1024; // 8 MB
        JustAudioMediaKit.title = "Fadeplay";
        JustAudioMediaKit.protocolWhitelist = const ["file", "http", "https"];
        JustAudioMediaKit.pitch = false;
        JustAudioMediaKit.prefetchPlaylist = false;
        _initialized = true;
        logger.log("Audio Player successfully initialized");
        break;
      default:
        throw UnimplementedError(
          "AudioPlayer initialization hasn't been coded for $defaultTargetPlatform",
        );
    }
  }

  Future<bool> loadMusicFile(String musicFilepath) async {
    if (!_initialized) initialize();
    logger.log("Loading audio file at path $musicFilepath");
    final duration = await _player.setFilePath(musicFilepath);
    if (duration == null) {
      logger.warn("Error while loading file at path $musicFilepath");
    }
    return duration != null;
  }

  Future<void> play() async {
    _player.play();
  }
}
