import 'package:just_audio/just_audio.dart';

enum FullProcessingState {
  buffering,
  completed,
  idle,
  loading,
  ready,
  inTransition;

  static FullProcessingState ofProcessingState(ProcessingState state) =>
      switch (state) {
        ProcessingState.buffering => FullProcessingState.buffering,
        ProcessingState.completed => FullProcessingState.completed,
        ProcessingState.idle => FullProcessingState.idle,
        ProcessingState.loading => FullProcessingState.loading,
        ProcessingState.ready => FullProcessingState.ready,
      };

  ProcessingState toProcessingState() => switch (this) {
    FullProcessingState.buffering => ProcessingState.buffering,
    FullProcessingState.completed => ProcessingState.completed,
    FullProcessingState.idle => ProcessingState.idle,
    FullProcessingState.loading => ProcessingState.loading,
    FullProcessingState.ready => ProcessingState.ready,
    FullProcessingState.inTransition => ProcessingState.ready,
  };
}
