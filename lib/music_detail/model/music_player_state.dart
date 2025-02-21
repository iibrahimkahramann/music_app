class MusicPlayerState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isLooping;
  final String? errorMessage;

  MusicPlayerState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isLooping = false,
    this.errorMessage,
  });

  MusicPlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isLooping,
    String? errorMessage,
  }) {
    return MusicPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isLooping: isLooping ?? this.isLooping,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
