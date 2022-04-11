import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/options/options.dart';
import 'package:pulsar/placeholders/not_implemented.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/settings/report/report.dart';
import 'package:pulsar/widgets/route.dart';

class PostOptions extends StatelessWidget {
  final Post post;

  const PostOptions(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    Option notification = Option(
        name: 'Post Notifications',
        icon: MyIcons.notifications,
        onPressed: (context) {
          post.user.subcribeForPostNotifications(context,
              mode: post.user.postNotifications
                  ? RequestMethod.delete
                  : RequestMethod.post);
          Fluttertoast.showToast(
              msg:
                  'Post Notifications turned ${post.user.postNotifications ? "OFF" : "ON"}',
              gravity: ToastGravity.BOTTOM);
        });
    Option notInterested = Option(
        name: 'Not Interested',
        icon: MyIcons.notInterested,
        onPressed: (context) {
          toastNotImplemented();
        });
    Option block = Option(
        name: 'Block',
        icon: MyIcons.block,
        onPressed: (context) {
          post.user.block(context,
              mode: post.user.isBlocked
                  ? RequestMethod.delete
                  : RequestMethod.post);
        });
    Option report = Option(
        name: 'Report',
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: (context) {
          Navigator.of(context).push(myPageRoute(
              builder: (context) =>
                  ReportScreen(initialIndex: 1, user: post.user, post: post)));
        });

    Option download = Option(
        name: 'Download',
        icon: MyIcons.download,
        onPressed: (context) {
          toastNotImplemented();
        });

    Option edit = Option(
        name: 'Edit',
        icon: MyIcons.edit,
        onPressed: (context) {
          toastNotImplemented();
        });

    Option delete = Option(
        name: 'Delete',
        icon: MyIcons.delete,
        onPressed: (context) {
          post.delete(context, () {});
          // TODO: implement on delete post
        });

    List<Option> options = post.user.id == userProvider.user.id
        ? [download, edit, delete]
        : [notification, download, notInterested, block, report];

    return Options(options, share: true, shareText: 'post');
  }
}
