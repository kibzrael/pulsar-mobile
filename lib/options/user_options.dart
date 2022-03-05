import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/options/options.dart';
import 'package:pulsar/settings/report/report.dart';
import 'package:pulsar/widgets/route.dart';

class UserOptions extends StatelessWidget {
  final User user;

  const UserOptions(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Option notification = Option(
        name: 'Post Notifications',
        icon: MyIcons.notifications,
        onPressed: (context) {
          user.subcribeForPostNotifications(context,
              mode: user.postNotifications ?? false
                  ? RequestMethod.delete
                  : RequestMethod.post);
          Fluttertoast.showToast(
              msg:
                  'Post Notifications turned ${user.postNotifications ?? false ? "OFF" : "ON"}',
              gravity: ToastGravity.BOTTOM);
        });
    Option block = Option(
        name: 'Block',
        icon: MyIcons.block,
        onPressed: (context) {
          user.block(context,
              mode: user.isBlocked ?? false
                  ? RequestMethod.delete
                  : RequestMethod.post);
        });
    Option report = Option(
        name: 'Report',
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: (context) {
          Navigator.of(context).push(myPageRoute(
              builder: (context) => ReportScreen(initialIndex: 1, user: user)));
        });

    List<Option> options = [notification, block, report];
    return Options(
      options,
      share: true,
      shareText: "user @${user.username}",
    );
  }
}
