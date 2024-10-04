class RecordingState {
  final bool isRecordingAudio;
  final bool isRecordingVideo;
  final bool hasRecordedAudio;
  final bool hasRecordedVideo;
  final Duration audioDuration;
  final Duration videoDuration;

  RecordingState({
    this.isRecordingAudio = false,
    this.isRecordingVideo = false,
    this.hasRecordedAudio = false,
    this.hasRecordedVideo = false,
    this.audioDuration = Duration.zero,
    this.videoDuration = Duration.zero,
  });

  RecordingState copyWith({
    bool? isRecordingAudio,
    bool? isRecordingVideo,
    bool? hasRecordedAudio,
    bool? hasRecordedVideo,
    Duration? audioDuration,
    Duration? videoDuration,
  }) {
    return RecordingState(
      isRecordingAudio: isRecordingAudio ?? this.isRecordingAudio,
      isRecordingVideo: isRecordingVideo ?? this.isRecordingVideo,
      hasRecordedAudio: hasRecordedAudio ?? this.hasRecordedAudio,
      hasRecordedVideo: hasRecordedVideo ?? this.hasRecordedVideo,
      audioDuration: audioDuration ?? this.audioDuration,
      videoDuration: videoDuration ?? this.videoDuration,
    );
  }
}