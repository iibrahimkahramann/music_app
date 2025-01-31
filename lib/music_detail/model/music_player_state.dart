class MusicPlayerState {
  final bool isPlaying;
  final Duration? duration;
  final Duration? position;
  final String? errorMessage;

  MusicPlayerState({
    this.isPlaying = false,
    this.duration,
    this.position,
    this.errorMessage,
  });

  MusicPlayerState copyWith({
    bool? isPlaying,
    Duration? duration,
    Duration? position,
    String? errorMessage,
  }) {
    return MusicPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
