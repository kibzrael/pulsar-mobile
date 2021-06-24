import 'package:flutter/material.dart';
import 'package:pulsar/secondary_pages.dart/tag_page.dart';
import 'package:pulsar/widgets/route.dart';

class FollowedTags extends StatefulWidget {
  @override
  _FollowedTagsState createState() => _FollowedTagsState();
}

class _FollowedTagsState extends State<FollowedTags> {
  List<String> tags = [
    'Celebrity',
    'Music',
    'Sarcasm',
    'Photography',
    'Karaoke'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        width: double.infinity,
        margin: EdgeInsets.only(top: 5),
        alignment: Alignment.bottomCenter,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: tags.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.of(context)
                        .push(myPageRoute(builder: (context) => TagPage()));
                  },
                  child: Chip(
                    backgroundColor: Theme.of(context).cardColor,
                    //: Colors.grey[100],
                    elevation: 1,
                    label: Text(
                      '${tags[index]}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
              );
            }));
  }
}
