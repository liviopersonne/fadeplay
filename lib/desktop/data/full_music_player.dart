import 'dart:async';

import 'package:fadeplay/desktop/data/logger.dart';
import 'package:fadeplay/desktop/data/single_music_player.dart';
import 'package:fadeplay/desktop/settings/settings.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

final logger = Logging("FullMusicPlayer");

/// A music player with 2 AudioPlayers than can crossfade between tracks
class FullMusicPlayer {
  final _player0 = SingleMusicPlayer();
  final _player1 = SingleMusicPlayer();
  StreamSubscription? _playerStatesSubscription;
  StreamSubscription? _precisePositionSubscription;
  int _activePlayerIndex = 0;

  /// Whether the player is playing
  var playing = false;

  /// The player's current state
  var state = ProcessingState.idle;

  FullMusicPlayer() {
    logger.debug("Insianciating a new FullMusicPlayer");

    // Setup listening streams
    final playerStatesStream = Rx.combineLatest2(
      _player0.player.playerStateStream,
      _player1.player.playerStateStream,
      (s0, s1) => (s0, s1),
    );

    _playerStatesSubscription = playerStatesStream.listen((states) {
      final (s0, s1) = states;
      _onNewPlayerStates(s0, s1);
    });
  }

  /// Dispose the player when you're done using it
  Future<void> dispose() async {
    _playerStatesSubscription?.cancel();
    _playerStatesSubscription = null;
    _precisePositionSubscription?.cancel();
    _precisePositionSubscription = null;
    _player0.dispose();
    _player1.dispose();
    logger.debug("Disposed a FullMusicPlayer");
  }

  /// Gets the SingleMusicPlayer that is currently playing
  SingleMusicPlayer _getActivePlayer() =>
      _activePlayerIndex == 0 ? _player0 : _player1;

  /// Gets the SingleMusicPlayer that isn't currently playing
  SingleMusicPlayer _getInactivePlayer() =>
      _activePlayerIndex == 0 ? _player1 : _player0;

  /// Switches between the two SingleMusicPlayers
  void _switchActivePlayer() {
    final oldIndex = _activePlayerIndex;
    final newIndex = 1 - _activePlayerIndex;
    logger.debug("Switching active player from $oldIndex to $newIndex");
    _activePlayerIndex = newIndex;
  }

  /// Actions to do when one of the player states changes
  void _onNewPlayerStates(PlayerState s0, PlayerState s1) {
    playing = s0.playing | s1.playing;
    state = _activePlayerIndex == 0 ? s0.processingState : s1.processingState;
  }

  /// Activates the more precise but ressource intensive stream
  /// that tracks the current position in the song
  /// - The `callback` function decides what to do when a new position is recieved
  void _activatePrecisePositionSubscription(void Function(Duration)? callback) {
    if (_precisePositionSubscription != null) {
      logger.error(
        "Tried to activate precise position subscription when it already existed",
      );
      _deactivatePrecisePositionSubscription();
    }
    _precisePositionSubscription = _getActivePlayer().precisePositionStream
        .listen(callback);
  }

  /// Deactivates the precise position stream to free ressources.
  /// This should always be called after a transition is completed
  void _deactivatePrecisePositionSubscription() {
    if (_precisePositionSubscription == null) {
      logger.error(
        "Tried to deactivate precise position subscription when it didn't exist",
      );
    }
    _precisePositionSubscription?.cancel();
    _precisePositionSubscription = null;
  }

  /// Plays the loaded music
  Future<void> play() async {
    logger.debug("Playing with activePlayer $_activePlayerIndex");
    if (playing) logger.warn("Called 'play' while already playing");
    await _getActivePlayer().play();
  }

  /// Pauses the player
  Future<void> pause() async {
    logger.debug("Paused player");
    if (!playing) logger.warn("Called 'pause' while already paused");
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
