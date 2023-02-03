import 'package:flutter/material.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/section.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool comment = false;
  bool repost = false;
  bool download = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: SingleChildScrollView(
        child: Column(children: [
          const MyListTile(title: 'Blocked Accounts'),
          const SizedBox(height: 15),
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
          const MyListTile(
            title: 'Mentions',
            subtitle: 'Anyone',
          ),
          const MyListTile(
            title: 'Messaging',
            subtitle: 'Following',
          ),
          const MyListTile(
            title: 'Information Privacy',
            subtitle: 'email, phone, social media',
          )
        ]),
      ),
    );
  }
}
