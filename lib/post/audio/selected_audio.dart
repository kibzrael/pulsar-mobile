import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/post/audio/audio_widget.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class SelectedAudio extends StatefulWidget {
  final Audio audio;
  final Function() onBack;
  final Function() pop;
  SelectedAudio(this.audio, {required this.onBack, required this.pop});
  @override
  _SelectedAudioState createState() => _SelectedAudioState();
}

class _SelectedAudioState extends State<SelectedAudio> {
  double originalVolume = 0.5;
  double audioVolume = 0.5;

  Audio get audio => widget.audio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Audio'),
          leading: IconButton(
            icon: Icon(MyIcons.back),
            onPressed: () {
              openDialog(
                      context,
                      (context) => MyDialog(
                            title: 'Caution!',
                            body:
                                'The selected audio and changes you\'ve made would be lost if you quit.',
                            actions: ['Cancel', 'Ok'],
                            destructive: 'Ok',
                          ),
                      dismissible: true)
                  .then((value) {
                if (value == 'Ok') {
                  if (Provider.of<PostProvider>(context, listen: false).audio !=
                      null) {
                    widget.pop();
                  } else {
                    widget.onBack();
                  }
                }
              });
            },
          ),
          actions: [
            MyTextButton(
                text: 'Done',
                onPressed: () {
                  Provider.of<PostProvider>(context, listen: false).audio =
                      audio;
                  widget.pop();
                })
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.width / 3,
          margin: EdgeInsets.symmetric(vertical: 7.5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white12,
              image: DecorationImage(
                  image: NetworkImage(audio.coverPhoto), fit: BoxFit.cover)),
        ),
        Text(
          audio.name,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          audio.artist,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Visibility(
          visible:
              Provider.of<PostProvider>(context, listen: false).audio != null,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: InkWell(
            onTap: () {
              Provider.of<PostProvider>(context, listen: false).audio = null;
              widget.onBack();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Icon(
                    MyIcons.delete,
                    size: 45,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Remove',
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
            ),
          ),
        ),
        Spacer(),
        AudioWidget(),
        Spacer(flex: 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Original:',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Slider(
                    value: originalVolume,
                    onChanged: (double value) {
                      setState(() {
                        originalVolume = value;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Audio:',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Slider(
                    value: audioVolume,
                    label: '100',
                    onChanged: (double value) {
                      setState(() {
                        audioVolume = value;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}
