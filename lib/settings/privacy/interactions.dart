import 'package:flutter/material.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/section.dart';

class Interactions extends StatefulWidget {
  @override
  _InteractionsState createState() => _InteractionsState();
}

class _InteractionsState extends State<Interactions> {
  bool comment = false;
  bool repost = false;
  bool download = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interactions')),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            MyListTile(title: 'Blocked Accounts'),
            SizedBox(height: 15),
            Section(
                title: 'Posts',
                child: Column(
                  children: [
                    MyListTile(
                      title: 'Comment',
                      trailingArrow: false,
                      trailing: Switch.adaptive(
                          value: comment,
                          onChanged: (value) => setState(() {
                                comment = value;
                              })),
                    ),
                    MyListTile(
                      title: 'Repost',
                      trailingArrow: false,
                      trailing: Switch.adaptive(
                          value: repost,
                          onChanged: (value) => setState(() {
                                repost = value;
                              })),
                    ),
                    MyListTile(
                      title: 'Download',
                      trailingArrow: false,
                      trailing: Switch.adaptive(
                          value: download,
                          onChanged: (value) => setState(() {
                                download = value;
                              })),
                    ),
                  ],
                )),
            MyListTile(
              title: 'Mentions',
              subtitle: 'Anyone',
            ),
            MyListTile(
              title: 'Messaging',
              subtitle: 'Following',
            )
          ]),
        ),
      ),
    );
  }
}
