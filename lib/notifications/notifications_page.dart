import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/notifications/notification_card.dart';
import 'package:pulsar/pages/route_observer.dart';
import 'package:pulsar/widgets/route.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  GlobalKey<NavigatorState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Provider.of<BasicRootProvider>(context, listen: false)
        .pageNavigators
        .putIfAbsent(3, () => key);
    return Navigator(
      key: key,
      initialRoute: '/',
      observers: [MyRouteObserver(context, 3)],
      onGenerateRoute: (settings) {
        return myPageRoute(
            settings: settings,
            builder: (context) => const RootNotificationsPage());
      },
    );
  }
}

class RootNotificationsPage extends StatefulWidget {
  const RootNotificationsPage({Key? key}) : super(key: key);

  @override
  _RootNotificationsPageState createState() => _RootNotificationsPageState();
}

class _RootNotificationsPageState extends State<RootNotificationsPage> {
  List<User> users = [
    tom,
    beth,
    melissa,
    thomas,
    nick,
    joy,
    lizzy,
    evah,
    joe,
    chris
  ];

  List<Interaction> types = [
    Interaction.like,
    Interaction.follow,
    Interaction.repost,
    Interaction.comment
  ];

  Future onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [IconButton(icon: Icon(MyIcons.tune), onPressed: () {})],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return InteractionNotificationCard(users[index],
                type: types[index % 4]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 12,
            );
          },
        ),
      ),
    );
  }
}
