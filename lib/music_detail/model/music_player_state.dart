class MusicPlayerState {
  final bool isPlaying;
  final bool isShuffling;
  final bool isLooping;
  final Duration? duration;
  final Duration? position;
  final String? errorMessage;

  MusicPlayerState({
    this.isPlaying = false,
    this.isShuffling = false,
    this.isLooping = false,
    this.duration,
    this.position,
    this.errorMessage,
  });

  MusicPlayerState copyWith({
    bool? isPlaying,
    bool? isShuffling,
    bool? isLooping,
    Duration? duration,
    Duration? position,
    String? errorMessage,
  }) {
    return MusicPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffling: isShuffling ?? this.isShuffling,
      isLooping: isLooping ?? this.isLooping,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
