
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:club8/models/recording_state.dart';
import 'dart:async';

class RecordingNotifier extends StateNotifier<RecordingState> {
  RecordingNotifier() : super(RecordingState());

void startAudioRecording() {
  state = state.copyWith(isRecordingAudio: true, hasRecordedAudio: false, audioDuration: Duration.zero);
  startAudioRecordingTimer();
}

 void startAudioRecordingTimer() {
  Timer.periodic(Duration(seconds: 1), (timer) {
    if (state.isRecordingAudio) {
      updateAudioDuration(state.audioDuration + Duration(seconds: 1));
    } else {
      timer.cancel();
    }
  });
}

 

  void stopAudioRecording() {
    state = state.copyWith(isRecordingAudio: false, hasRecordedAudio: true);
  }

  void startVideoRecording() {
    state = state.copyWith(isRecordingVideo: true, hasRecordedVideo: false, videoDuration: Duration.zero);
  }

  void stopVideoRecording() {
    state = state.copyWith(isRecordingVideo: false, hasRecordedVideo: true);
  }

  void deleteAudioRecording() {
    state = state.copyWith(hasRecordedAudio: false, audioDuration: Duration.zero);
  }

  void deleteVideoRecording() {
    state = state.copyWith(hasRecordedVideo: false, videoDuration: Duration.zero);
  }

  void updateAudioDuration(Duration duration) {
    state = state.copyWith(audioDuration: duration);
  }

  void updateVideoDuration(Duration duration) {
    state = state.copyWith(videoDuration: duration);
  }
}
