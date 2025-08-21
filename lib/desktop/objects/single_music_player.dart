import 'dart:async';
import 'dart:ui';

import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/settings/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:just_audio/just_audio.dart';

final logger = Logging("SingleMusicPlayer");

/// A music player with a single AudioPlayer than can fade in and out.
/// This player auto pauses when the track index advances, either manually or automatically
class SingleMusicPlayer {
  static var _initialized = false;
  final player = AudioPlayer();
  StreamSubscription? _pauseOnNewTrackSubscription;
  int? _currentIndex;
  int? _playlistLength;

  /// Whether the player is playing
  var playing = false;

  /// A precise stream of the current position in the song used for transitionf
  late final Stream<Duration> precisePositionStream;

  /// A stream that sends the new values of `_currentIndex`
  late final Stream<int?> newCurrentIndexStream;
  late final StreamController<int?> _newIndexController;

  /// Setup platform specific settings
  static void initialize() {
    logger.debug("Initializing Audio Player settings...");
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
        logger.debug("Audio Player settings successfully initialized");
        break;
      default:
        throw UnimplementedError(
          "AudioPlayer initialization hasn't been coded for $defaultTargetPlatform",
        );
    }
  }

  SingleMusicPlayer() {
    logger.debug("Insianciating a new SingleMusicPlayer");
    if (!_initialized) initialize();

    precisePositionStream = player.createPositionStream(
      minPeriod: Settings.bestTransitionPrecision,
      maxPeriod: Settings.worstTransitionPrecision,
    );

    _newIndexController = StreamController<int?>.broadcast();
    newCurrentIndexStream = _newIndexController.stream;

    _pauseOnNewTrackSubscription = player.currentIndexStream.listen((
      newIndex,
    ) async {
      final realNewIndex = newIndex == null ? null : newIndex - 1;
      final oldIndex = _currentIndex;
      if (realNewIndex != oldIndex) {
        logger.log("Got new index: $realNewIndex");
        // emit new value to newCurrentIndexStream
        _newIndexController.add(realNewIndex);
        _currentIndex = realNewIndex;

        if (realNewIndex != null &&
            oldIndex != null &&
            realNewIndex == oldIndex + 1) {
          // We have advanced by one track automatically or manually
          logger.debug("New track just started, auto pausing player");
          await player.pause();
          await player.seek(Duration.zero);
        }
      }
    });
  }

  /// Dispose the player when you're done using it
  Future<void> dispose() async {
    _pauseOnNewTrackSubscription?.cancel();
    _pauseOnNewTrackSubscription = null;
    await player.dispose();
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
    final duration = await player.setFilePath(musicFilepath);
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

    // Add silence sentinels at the beginning and end of playlist
    // This is used so we can properly call `next` to reach the last track of the playlist
    // or `prev` to reach the first track
    final silence = AudioSource.asset('asset:///2-seconds-of-silence.mp3');
    audioSources.add(silence);
    audioSources.insert(0, silence);

    final duration = await player.setAudioSources(
      audioSources,
      preload: preload,
      initialIndex: (initialIndex ?? 0) + 1,
      initialPosition: initialPosition,
    );
    return duration != null;
  }

  /// Plays the loaded music
  Future<void> play() async {
    logger.debug(
      "Reading ${player.audioSources.length} tracks at position ${player.currentIndex} with volume ${player.volume}",
    );
    await player.play();
  }

  /// Pauses the player
  Future<void> pause() async {
    await player.pause();
  }

  /// Goes to next music without any transition
  Future<void> next() async {
    if (player.hasNext) {
      await player.seekToNext();
    } else {
      logger.warn("Reached the end of the playlist");
      player.seek(Duration.zero, index: null);
    }
  }

  /// Goes to the previous music without any transition
  Future<void> prev() async {
    if (_currentIndex != null && _currentIndex! >= 0) {
      await player.seekToPrevious();
    } else {
      logger.warn("Tried to seek previous track when there weren't any");
      player.seek(Duration.zero, index: null);
    }
  }

  /// Seeks to a specific point of the music
  Future<void> seek(Duration position) async {
    await player.seek(position);
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
      player.setVolume(volume);
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
    if (!player.playing) {
      logger.error("Tried to fade out while player is not playing");
      return;
    }

    await _fade(
      startVolume: player.volume,
      endVolume: 0,
      duration: duration,
      stepTime: stepTime,
    );
    await pause();
    await player.setVolume(Settings.playerVolume);
  }

  /// Fades a music in if there is music loaded
  /// - duration: Full fadein time
  /// - stepTime: Time between 2 volume modifications (defaults to 60 fps)
  Future<void> fadein({
    required Duration duration,
    Duration stepTime = const Duration(milliseconds: 16),
  }) async {
    final playerState = player.playerState.processingState;
    if (playerState != ProcessingState.ready) {
      logger.error(
        "Tried to fade in while the player wasn't ready but in state $playerState",
      );
      return;
    }
    if (player.playing) {
      logger.error("Tried to fade in while the player was already playing");
      return;
    }

    await player.setVolume(0);
    await play();
    await _fade(
      startVolume: 0,
      endVolume: Settings.playerVolume,
      duration: duration,
      stepTime: stepTime,
    );
  }
}
