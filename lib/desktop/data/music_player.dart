import 'dart:async';
import 'dart:ui';

import 'package:fadeplay/desktop/data/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:media_kit/media_kit.dart';
import 'package:just_audio/just_audio.dart';

final logger = Logging("AudioPlayer");

/// An music player with a single AudioPlayer than can fade in and out
class MusicPlayer {
  static var _initialized = false;
  final _player = AudioPlayer();

  /// Dispose the player when you're done using it
  Future<void> dispose() async {
    await _player.dispose();
  }

  /// Setup platform specific settings using the AudioPlayer
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

  /// Loads a music from its filepath
  Future<bool> loadMusicFile(String musicFilepath) async {
    if (!_initialized) initialize();
    logger.log("Loading audio file at path $musicFilepath");
    final duration = await _player.setFilePath(musicFilepath);
    if (duration == null) {
      logger.warn("Error while loading file at path $musicFilepath");
    }
    return duration != null;
  }

  /// Plays the loaded music
  Future<void> play() async {
    _player.play();
  }

  /// Pauses the player
  Future<void> pause() async {
    _player.pause();
  }

  /// Fades volume from startVolume to endVolume in duration time and with step steps
  Future<void> _fade({
    required double startVolume,
    required double endVolume,
    required Duration duration,
    required Duration stepTime,
  }) async {
    final completer = Completer<void>();
    double elapsed = 0;

    Timer.periodic(stepTime, (timer) {
      final t = (elapsed / duration.inMilliseconds).clamp(0.0, 1.0);
      final volume = lerpDouble(startVolume, endVolume, t)!;
      _player.setVolume(volume);
      elapsed += stepTime.inMilliseconds;

      if (t >= 1) {
        timer.cancel();
        completer.complete();
      }

      // TODO: Check for other cancel situations
      // TODO: Check if linear interpolation sounds linear to the ear
    });

    return completer.future;
  }

  /// Fades a music out if there is one playing
  /// - duration: Full fadeout time
  /// - stepTime: Time between 2 volume modifications (defaults to 60 fps)
  Future<void> fadeout({
    required Duration duration,
    Duration stepTime = const Duration(milliseconds: 16),
  }) async {
    if (!_player.playing) {
      logger.warn("Tried to fade out while player is not playing");
      return;
    }

    await _fade(
      startVolume: _player.volume,
      endVolume: 0,
      duration: duration,
      stepTime: stepTime,
    );
    await pause();
  }

  /// Fades a music in if there is music loaded
  /// - duration: Full fadein time
  /// - stepTime: Time between 2 volume modifications (defaults to 60 fps)
  Future<void> fadein({
    required Duration duration,
    Duration stepTime = const Duration(milliseconds: 16),
  }) async {
    if (_player.audioSource == null) {
      logger.warn("Tried to fade in while no song was loaded");
      return;
    }
    if (_player.playing) {
      logger.warn("Tried to fade in while the player was already playing");
      return;
    }

    await play();
    await _fade(
      startVolume: 0,
      endVolume: 1, // TODO: Get correct player volume
      duration: duration,
      stepTime: stepTime,
    );
  }
}
