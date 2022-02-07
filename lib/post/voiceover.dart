import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pulsar/classes/icons.dart';

class Voiceover extends StatefulWidget {
  const Voiceover({Key? key}) : super(key: key);

  @override
  _VoiceoverState createState() => _VoiceoverState();
}

class _VoiceoverState extends State<Voiceover> {
  late FlutterSoundRecorder recorder;

  String? audio;
  RecordingDisposition? disposition;

  @override
  void initState() {
    super.initState();
    recorder = FlutterSoundRecorder();
    initialize();
  }

  initialize() async {
    PermissionStatus status = await Permission.microphone.request();

    if (!status.isGranted) return;

    await recorder.openRecorder();

    final AudioSession session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  record() async {
    Directory temp = await getTemporaryDirectory();
    String path = join(temp.path, 'audio${DateTime.now()}.aac');
    await recorder.startRecorder(
      toFile: path,
    );
    print('started...');
    recorder.onProgress?.listen((RecordingDisposition event) {
      print('recording....');
      setState(() {
        disposition = event;
      });
    });
  }

  stopRecording() async {
    audio = await recorder.stopRecorder();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Voiceover')),
      body: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(audio ?? 'Record...'),
            SizedBox(height: 15),
            ElevatedButton.icon(
                onPressed: record,
                icon: Icon(MyIcons.mic),
                label: Text('Record')),
            SizedBox(height: 15),
            Text('State: ${recorder.recorderState.name}'),
            SizedBox(height: 5),
            Text('Duration: ${disposition?.duration.toString()}'),
            SizedBox(height: 5),
            Text('Decibles: ${disposition?.decibels}'),
            SizedBox(height: 15),
            ElevatedButton.icon(
                onPressed: stopRecording,
                icon: Icon(Icons.stop),
                label: Text('Stop')),
          ],
        ),
      ),
    );
  }
}
