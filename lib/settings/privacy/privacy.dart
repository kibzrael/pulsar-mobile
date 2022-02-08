import 'package:flutter/material.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/section.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool comment = false;
  bool repost = false;
  bool download = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy')),
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
            ),
            MyListTile(
              title: 'Information Privacy',
              subtitle: 'email, phone, social media',
            )
          ]),
        ),
      ),
    );
  }
}
