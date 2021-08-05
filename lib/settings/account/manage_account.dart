import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/section.dart';

class ManageAccount extends StatefulWidget {
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  User user = tahlia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Account'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        backgroundColor: Theme.of(context).dividerColor,
                        backgroundImage: AssetImage(user.profilePic),
                        radius: 36),
                    SizedBox(width: 15),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('@${user.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontSize: 21)),
                          SizedBox(
                            height: 2.5,
                          ),
                          Text('${user.category}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(fontSize: 18)),
                        ])
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              MyListTile(
                title: 'Email',
                trailingText: 'kibraphael7@gmail.com',
                flexRatio: [2, 3],
              ),
              MyListTile(
                title: 'Phone',
                trailingText: '0723573568',
                flexRatio: [2, 3],
              ),
              MyListTile(
                title: 'Password',
                trailingText: '********',
                flexRatio: [2, 3],
              ),
              SizedBox(
                height: 30,
              ),
              Section(
                title: 'Linked Accounts',
                trailing: Icon(MyIcons.addOutlined),
                child: Column(children: [
                  MyListTile(
                    title: 'Facebook',
                    leading: Icon(MyIcons.facebook, size: 36),
                    subtitle: '@${user.username}',
                  ),
                  MyListTile(
                    title: 'Google',
                    leading: Icon(MyIcons.google, size: 36),
                    subtitle: '@${user.username}',
                  ),
                  MyListTile(
                    title: 'Twitter',
                    leading: Icon(MyIcons.twitter, size: 36),
                    subtitle: '@${user.username}',
                  ),
                  MyListTile(
                    title: 'Instagram',
                    leading: Icon(MyIcons.instagram, size: 36),
                    subtitle: '@${user.username}',
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
