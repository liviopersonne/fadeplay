import 'package:fadeplay/desktop/data/logger.dart';
import 'package:fadeplay/desktop/data/single_music_player.dart';
import 'package:fadeplay/desktop/settings/settings.dart';
import 'package:just_audio/just_audio.dart';

final logger = Logging("FullMusicPlayer");

/// A music player with 2 AudioPlayers than can crossfade between tracks
class FullMusicPlayer {
  final _player0 = SingleMusicPlayer();
  final _player1 = SingleMusicPlayer();
  int _activePlayerIndex = 0;

  /// Dispose the player when you're done using it
  Future<void> dispose() async {
    _player0.dispose();
    _player1.dispose();
    logger.debug("Disposed a FullMusicPlayer");
  }

  SingleMusicPlayer _getActivePlayer() =>
      _activePlayerIndex == 0 ? _player0 : _player1;

  SingleMusicPlayer _getInactivePlayer() =>
      _activePlayerIndex == 0 ? _player1 : _player0;

  void _switchActivePlayer() {
    final oldIndex = _activePlayerIndex;
    final newIndex = 1 - _activePlayerIndex;
    logger.debug("Switching active player from $oldIndex to $newIndex");
    _activePlayerIndex = newIndex;
  }

  /// Plays the loaded music
  Future<void> play() async {
    logger.debug("Playing with activePlayer $_activePlayerIndex");
    await _getActivePlayer().play();
  }

  /// Pauses the player
  Future<void> pause() async {
    logger.debug("Paused player");
    await Future.wait([
      _getActivePlayer().pause(),
      _getInactivePlayer().pause(),
    ]);
  }

  /// Goes to next music without any transition
  Future<void> next() async {
    // TODO: Deal with end of playlist

    final wasPlaying = _getActivePlayer().playing;
    await _getActivePlayer().pause();
    await _getActivePlayer().next();
    _switchActivePlayer();
    if (wasPlaying) await _getActivePlayer().play();
  }

  /// Goes to the previous music without any transition
  Future<void> prev() async {
    // TODO: Deal with start of playlist

    final wasPlaying = _getActivePlayer().playing;
    await _getActivePlayer().pause();
    await _getActivePlayer().restartSong();
    _switchActivePlayer();
    await _getActivePlayer().prev();
    await _getActivePlayer().restartSong();
    if (wasPlaying) await _getActivePlayer().play();
  }

  Future<void> crossfadeNext({Duration? crossfadeDuration}) async {
    final duration = crossfadeDuration ?? Settings.crossfadeDuration;

    if (!_getActivePlayer().playing) {
      logger.warn("Tried to crossfade while paused");
      return await next();
    }

    // TODO: Warn if there is no music left

    await Future.wait([
      _getActivePlayer().fadeout(duration: duration),
      _getInactivePlayer().fadein(duration: duration),
    ]);

    await _getActivePlayer().next();
    _switchActivePlayer();
  }

  /// Loads a list of music in order
  Future<bool> loadPlaylist({
    required List<String> filePaths,
    bool preload = true,
    int? initialIndex,
    Duration? initialPosition,
  }) async {
    logger.debug("Loading playlist of ${filePaths.length} song(s)");

    // FIXME: Deal with end of playlist

    // Set audio sources
    final audioSources = filePaths
        .map((filePath) => AudioSource.uri(Uri.file(filePath)))
        .toList();
    List<AudioSource> audioSources1 = [];
    List<AudioSource> audioSources2 = [];
    for (var i = 0; i < audioSources.length; i++) {
      if (i % 2 == 0) {
        audioSources1.add(audioSources[i]);
      } else {
        audioSources2.add(audioSources[i]);
      }
    }

    // Set initial values
    final (initialIndex1, initialIndex2) = initialIndex == null
        ? (null, null)
        : ((initialIndex + 1) ~/ 2, initialIndex ~/ 2);

    final (
      initialPosition1,
      initialPosition2,
    ) = (initialPosition == null || initialIndex == null)
        ? (null, null)
        : (initialIndex % 2 == 0)
        ? (initialPosition, null)
        : (null, initialPosition);

    final success1 = await _player0.loadPlaylist(
      audioSources: audioSources1,
      preload: preload,
      initialIndex: initialIndex1,
      initialPosition: initialPosition1,
    );
    final success2 = await _player1.loadPlaylist(
      audioSources: audioSources2,
      preload: preload,
      initialIndex: initialIndex2,
      initialPosition: initialPosition2,
    );

    // set active player to _player0 if the initial index is pair, and vice versa
    _activePlayerIndex = (initialIndex ?? 0) % 2;

    return success1 && success2;
  }
}
