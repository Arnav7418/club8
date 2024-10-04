import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:club8/providers/recording_providers.dart';
import 'package:club8/models/recording_state.dart';

final recordingProvider = StateNotifierProvider<RecordingNotifier, RecordingState>((ref) => RecordingNotifier());



class Second extends ConsumerWidget {
  const Second({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingState = ref.watch(recordingProvider);

    return Scaffold(
      backgroundColor: const Color(0xff101010),
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        //title: const Text("8 club", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xff151515),
      ),
      body: Column(
        children: [
          Spacer(),
          introText(),
          subtitleText(),
          inputField(),
          if (recordingState.isRecordingAudio || recordingState.hasRecordedAudio)
            AudioRecordingCard(),
          if (recordingState.isRecordingVideo || recordingState.hasRecordedVideo)
            VideoRecordingCard(),
          if (!recordingState.hasRecordedAudio && !recordingState.hasRecordedVideo)
            RecordingButtons(),
          NextButton(),
        ],
      ),
    );
  }

  Widget inputField() {
    return CustomTextField(
      minLines: 5,
      maxLines: 10,
      inputFormatter: LengthLimitingTextInputFormatter(600),
      hintText: " / Start typing here",
      onChanged: (value) {},
    );
  }

  Widget subtitleText() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        "Tell us about your intent and what motivates you to create experiences.",
        style: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0x7fffffff),
        ),
      ),
    );
  }

  Widget introText() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        "Why do you want to host with us?",
        style: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ),
    );
  }
}
class AudioRecordingCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingState = ref.watch(recordingProvider);
    final notifier = ref.read(recordingProvider.notifier);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff151515),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0x7fffffff)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.mic, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  recordingState.isRecordingAudio ? 'Recording audio...' : 'Audio recorded',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Text(
                _formatDuration(recordingState.audioDuration),
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(width: 8),
              if (recordingState.isRecordingAudio)
                TextButton(
                  onPressed: () => notifier.stopAudioRecording(),
                  child: Icon(Icons.cancel, color: Color(0xff5961ff)),
                ),
              if (!recordingState.isRecordingAudio)
                IconButton(
                  icon: Icon(Icons.delete, color: Color(0xff5961ff)),
                  onPressed: () => notifier.deleteAudioRecording(),
                ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: recordingState.isRecordingAudio ? null : 1,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
class VideoRecordingCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingState = ref.watch(recordingProvider);
    final notifier = ref.read(recordingProvider.notifier);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff151515),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0x7fffffff)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.videocam, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  recordingState.isRecordingVideo ? 'Recording video...' : 'Video recorded',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              if (recordingState.isRecordingVideo)
                TextButton(
                  onPressed: () => notifier.stopVideoRecording(),
                  child: Icon(Icons.cancel,color: Color(0xff5961ff),),
                ),
              if (!recordingState.isRecordingVideo)
                IconButton(
                  icon: Icon(Icons.delete, color: Color(0xff5961ff)),
                  onPressed: () => notifier.deleteVideoRecording(),
                ),
            ],
          ),
          SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.grey[800],
              child: Center(
                child: Icon(Icons.video_library, color: Colors.white, size: 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecordingButtons extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recordingProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => notifier.startAudioRecording(),
          icon: Icon(Icons.mic),
          label: Text('Record Audio'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff151515),
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => notifier.startVideoRecording(),
          icon: Icon(Icons.videocam),
          label: Text('Record Video'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff151515),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          print("Next button tapped");
        },
        child: Text("Next"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff151515),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Color(0x7fffffff)),
          ),
        ),
      ),
    );
  }
}

// CustomTextField widget
class CustomTextField extends StatelessWidget {
  final int? minLines;
  final int? maxLines;
  final TextInputFormatter? inputFormatter;
  final String? hintText;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    this.minLines,
    this.maxLines,
    this.inputFormatter,
    this.hintText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff151515),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0x7fffffff)),
      ),
      child: TextField(
        minLines: minLines,
        maxLines: maxLines,
        inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0x7fffffff)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        onChanged: onChanged,
      ),
    );
  }
}