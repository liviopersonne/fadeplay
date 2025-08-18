import 'dart:async';
import 'dart:ui';

import 'package:fadeplay/desktop/data/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:just_audio/just_audio.dart';

final logger = Logging("SingleMusicPlayer");

/// A music player with a single AudioPlayer than can fade in and out
class SingleMusicPlayer {
  static var _initialized = false;
  final _player = AudioPlayer();
  StreamSubscription? _playerStateSubscription;

  /// Whether the player is playing
  var playing = false;

  /// Setup platform specific settings
  static void initialize() {
    logger.debug("Initializing Audio Player...");
    switch (defaultTargetPlatform) {
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        JustAudioMediaKit.ensureInitialized();
        JustAudioMediaKit.mpvLogLevel = media_kit.MPVLogLevel.warn;
        JustAudioMediaKit.bufferSize = 8 * 1024 * 1024; // 8 MB
        JustAudioMediaKit.title = "Fadeplay";
        JustAudioMediaKit.protocolWhitelist = const ["file", "http", "https"];
        JustAudioMediaKit.pitch = false;
        JustAudioMediaKit.prefetchPlaylist = false;
        _initialized = true;
        logger.debug("Audio Player successfully initialized");
        break;
      default:
        throw UnimplementedError(
          "AudioPlayer initialization hasn't been coded for $defaultTargetPlatform",
        );
    }
  }

  /// Setup listening streams
  SingleMusicPlayer() {
    logger.debug("Insianciating a new SingleMusicPlayer");
    if (!_initialized) initialize();
    _playerStateSubscription = _player.playerStateStream.listen((
      PlayerState newState,
    ) {
      playing = newState.playing;
    });
  }

  /// Dispose the player when you're done using it
  Future<void> dispose() async {
    _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    await _player.dispose();
    logger.debug("Disposed a SingleMusicPlayer");
  }

  /// Loads a music from its filepath
  Future<bool> loadMusicFile(String musicFilepath) async {
    logger.debug("Loading audio file at path $musicFilepath");
    if (playing) {
      logger.error(
        "Tried to load an audio file while the player was already playing",
      );
      return false;
    }
    final duration = await _player.setFilePath(musicFilepath);
    if (duration == null) {
      logger.warn("Error while loading file at path $musicFilepath");
    }
    return duration != null;
  }

  /// Sets the next music files that this player will play
  Future<bool> loadPlaylist({
    required List<AudioSource> audioSources,
    bool preload = true,
    int? initialIndex,
    Duration? initialPosition,
  }) async {
    logger.debug("Loading playlist of ${audioSources.length} song(s)");
    if (playing) {
      logger.error(
        "Tried to load a playlist while the player was already playing",
      );
      return false;
    }
    if (initialIndex != null && initialIndex > audioSources.length) {
      logger.error(
        "The initial index $initialIndex is greater than the playlist length ${audioSources.length}",
      );
      return false;
    }

    final duration = await _player.setAudioSources(
      audioSources,
      preload: preload,
      initialIndex: initialIndex,
      initialPosition: initialPosition,
    );
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

  Future<void> next() async {
    _player.seekToNext();
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
      logger.error("Tried to fade out while player is not playing");
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
    final playerState = _player.playerState.processingState;
    if (playerState != ProcessingState.ready) {
      logger.error(
        "Tried to fade in while the player wasn't ready but in state $playerState",
      );
      return;
    }
    if (_player.playing) {
      logger.error("Tried to fade in while the player was already playing");
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
