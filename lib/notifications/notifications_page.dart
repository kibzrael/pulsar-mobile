import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/notifications/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<User> users = [
    tom,
    beth,
    melissa,
    thomas,
    rael,
    nick,
    joy,
    lizzy,
    evah,
    joe,
    chris
  ];

  Future onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [IconButton(icon: Icon(MyIcons.filterList), onPressed: () {})],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return InteractionNotificationCard(users[index]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 12,
            );
          },
        ),
      ),
    );
  }
}
