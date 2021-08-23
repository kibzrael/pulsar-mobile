import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/post/audio/search_audio.dart';
import 'package:pulsar/post/audio/selected_audio.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/transitions.dart';

class PostAudio extends StatefulWidget {
  final Function() pop;
  PostAudio({required this.pop});
  @override
  _PostAudioState createState() => _PostAudioState();
}

class _PostAudioState extends State<PostAudio> {
  Audio? audio;

  @override
  void initState() {
    super.initState();
    audio = Provider.of<PostProvider>(context, listen: false).audio;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      // margin: EdgeInsets.only(
      //   top: Provider.of<ThemeProvider>(context, listen: false).topPadding,
      // ),
      child: ScaledTransition(
        child: audio == null
            ? SearchAudio(
                onSelect: (selected) {
                  setState(() {
                    audio = selected;
                  });
                },
                pop: widget.pop)
            : SelectedAudio(audio!, onBack: () {
                setState(() {
                  audio = null;
                });
              }, pop: widget.pop),
        reverse: audio == null,
      ),
    );
  }
}
