import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/data/challenges.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/search_field.dart';
import 'package:pulsar/widgets/text_button.dart';

class SearchAudio extends StatefulWidget {
  final Function(Audio selected) onSelect;
  final Function() pop;
  const SearchAudio({Key? key, required this.onSelect, required this.pop})
      : super(key: key);

  @override
  State<SearchAudio> createState() => _SearchAudioState();
}

class _SearchAudioState extends State<SearchAudio> {
  List<Audio> audios = [
    Audio(1,
        coverPhoto: litByFire.cover, name: 'Fire on fire', artist: 'Sam Smith'),
    Audio(2,
        coverPhoto: photographyChallenge.cover,
        name: 'Photograph',
        artist: 'Ed Sheeran'),
    Audio(3,
        coverPhoto: breakup.cover, name: 'Call you mine', artist: 'Bebe Rexha'),
    Audio(4,
        coverPhoto: danceChallenge.cover,
        name: 'Jump',
        artist: 'Julia Micheals'),
    Audio(5,
        coverPhoto: adventure.cover,
        name: 'Castle on the hill',
        artist: 'Ed Sheeran'),
    Audio(6,
        coverPhoto: urbanPortraits.cover,
        name: 'Take my breath',
        artist: 'The Weeknd')
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            titleSpacing: 0.0,
            title: SearchField(
              onChanged: (text) {},
              onSubmitted: (text) {},
              hintText: 'Search Audio...',
            ),
            leading: IconButton(
                onPressed: () {
                  widget.pop();
                },
                icon: Icon(MyIcons.close)),
            actions: [MyTextButton(text: 'Search', onPressed: () {})],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: audios.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  Audio audio = audios[index];
                  return MyListTile(
                    title: audio.name,
                    subtitle: audio.artist,
                    onPressed: () => widget.onSelect(audio),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: NetworkImage(audio.coverPhoto.thumbnail),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    trailingArrow: false,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white12),
                      child: Row(
                        children: [
                          Icon(MyIcons.play, size: 21),
                          const Text(
                            '1:30',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            width: 2,
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
