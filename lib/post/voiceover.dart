import 'package:flutter/material.dart';

class Voiceover extends StatefulWidget {
  const Voiceover({Key? key}) : super(key: key);

  @override
  _VoiceoverState createState() => _VoiceoverState();
}

class _VoiceoverState extends State<Voiceover> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Voiceover')),
    );
  }
}
