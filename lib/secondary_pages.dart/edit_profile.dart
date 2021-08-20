import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/secondary_pages.dart/profile_info.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';
import 'package:pulsar/widgets/text_button.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User user = tahlia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MyIcons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Edit Profile'),
        actions: [MyTextButton(text: 'Update', onPressed: () {})],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: kToolbarHeight),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfilePic(
                        user.profilePic,
                        radius: 60,
                      ),
                      SizedBox(height: 30),
                      MyListTile(
                          title: 'Username',
                          onPressed: () {
                            Navigator.of(context).push(myPageRoute(
                                builder: (context) => ProfileInfo('Username',
                                    maxCharacters: 12)));
                          },
                          flexRatio: [2, 3],
                          trailingText: '@${user.username}'),
                      MyListTile(
                          title: 'Full name',
                          onPressed: () {
                            Navigator.of(context).push(myPageRoute(
                                builder: (context) => ProfileInfo('Full name',
                                    maxCharacters: 15)));
                          },
                          flexRatio: [2, 3],
                          trailingText: '${user.username}'),
                      MyListTile(
                          title: 'Category',
                          onPressed: () {
                            Navigator.of(context).push(myPageRoute(
                                builder: (context) => ProfileInfo('Category',
                                    maxCharacters: 12)));
                          },
                          flexRatio: [2, 3],
                          trailingText: '${user.category}'),
                      MyListTile(
                          title: 'Bio',
                          onPressed: () {
                            Navigator.of(context).push(myPageRoute(
                                builder: (context) => ProfileInfo('Bio',
                                    multiline: true, maxCharacters: 80)));
                          },
                          flexRatio: [2, 3],
                          trailingText: ''),
                      MyListTile(
                          title: 'Portfolio',
                          onPressed: () {
                            Navigator.of(context).push(myPageRoute(
                                builder: (context) => ProfileInfo('Portfolio',
                                    maxCharacters: 12)));
                          },
                          flexRatio: [2, 3],
                          trailingText: ''),
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              Section(
                title: 'Display Info',
                child: Column(
                  children: [
                    MyListTile(
                      title: 'Email',
                      leading: Icon(MyIcons.email),
                      trailingArrow: false,
                    ),
                    MyListTile(
                      title: 'Phone',
                      leading: Icon(MyIcons.phone),
                      trailingArrow: false,
                    ),
                    MyListTile(
                      title: 'Facebook',
                      leading: Icon(MyIcons.facebook),
                      trailingArrow: false,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
