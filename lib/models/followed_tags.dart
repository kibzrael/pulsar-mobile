import 'package:flutter/material.dart';
import 'package:pulsar/secondary_pages.dart/tag_page.dart';
import 'package:pulsar/widgets/route.dart';

class FollowedTags extends StatefulWidget {
  const FollowedTags({Key? key}) : super(key: key);

  @override
  _FollowedTagsState createState() => _FollowedTagsState();
}

class _FollowedTagsState extends State<FollowedTags> {
  List<String> tags = ['Music', 'Art', 'Photography', 'Dance', 'Gymnastics'];
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 5),
        alignment: Alignment.bottomCenter,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shrinkWrap: true,
            itemCount: tags.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Navigator.of(context).push(myPageRoute(
                          builder: (context) => TagPage(tags[index])));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.2,
                              color: Theme.of(context).dividerColor,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        '#${tags[index]}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                    // Chip(
                    //   backgroundColor: Theme.of(context).cardColor,
                    //   //: Colors.grey[100],
                    //   elevation: 1,p
                    //   label: Text(
                    //     '#${tags[index]}',
                    //     style: Theme.of(context).textTheme.bodyText2,
                    //   ),
                    // ),
                    ),
              );
            }));
  }
}
