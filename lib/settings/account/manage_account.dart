import 'package:flutter/material.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/settings/account/change_password.dart';
import 'package:pulsar/settings/account/email.dart';
import 'package:pulsar/settings/account/phone.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';
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
                    ProfilePic(user.profilePic, radius: 36),
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
                            height: 5,
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
                onPressed: () => Navigator.of(context)
                    .push(myPageRoute(builder: (context) => ChangeEmail())),
              ),
              MyListTile(
                title: 'Phone',
                trailingText: '0723573568',
                flexRatio: [2, 3],
                onPressed: () => Navigator.of(context)
                    .push(myPageRoute(builder: (context) => ChangePhone())),
              ),
              MyListTile(
                title: 'Password',
                trailingText: '********',
                flexRatio: [2, 3],
                onPressed: () => Navigator.of(context)
                    .push(myPageRoute(builder: (context) => ChangePassword())),
              ),
              SizedBox(
                height: 30,
              ),
              Section(
                title: 'Linked Accounts',
                child: Column(children: [
                  MyListTile(
                    title: 'Facebook',
                    leading: Image(
                      image: AssetImage('assets/images/logos/facebook.png'),
                      width: 36,
                    ),
                    subtitle: '@${user.username}',
                  ),
                  MyListTile(
                    title: 'Google',
                    leading: Image(
                      image: AssetImage('assets/images/logos/google.png'),
                      width: 36,
                    ),
                    subtitle: '@${user.username}',
                  ),
                  MyListTile(
                    title: 'Twitter',
                    leading: Image(
                      image: AssetImage('assets/images/logos/twitter.png'),
                      width: 36,
                    ),
                    subtitle: '@${user.username}',
                  ),
                  MyListTile(
                    title: 'Instagram',
                    leading: Image(
                      image: AssetImage('assets/images/logos/instagram.png'),
                      width: 36,
                    ),
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
