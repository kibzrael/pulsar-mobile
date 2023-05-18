import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/options/options.dart';
import 'package:pulsar/placeholders/not_implemented.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/settings/report/report.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/route.dart';

class PostOptions extends StatelessWidget {
  final Post post;
  final Function() onDelete;

  const PostOptions(this.post, {Key? key, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    Option notification = Option(
        name: local(context).postNotifications,
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
        name: local(context).notInterested,
        icon: MyIcons.notInterested,
        onPressed: (context) {
          toastNotImplemented();
        });
    Option block = Option(
        name: local(context).block,
        icon: MyIcons.block,
        onPressed: (context) {
          post.user.block(context,
              mode: post.user.isBlocked
                  ? RequestMethod.delete
                  : RequestMethod.post);
        });
    Option report = Option(
        name: local(context).report,
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: (context) {
          Navigator.of(context).push(myPageRoute(
              builder: (context) =>
                  ReportScreen(initialIndex: 1, user: post.user, post: post)));
        });

    Option download = Option(
        name: local(context).download,
        icon: MyIcons.download,
        onPressed: (context) {
          toastNotImplemented();
        });

    Option edit = Option(
        name: local(context).edit,
        icon: MyIcons.edit,
        onPressed: (context) {
          toastNotImplemented();
        });

    Option delete = Option(
        name: local(context).delete,
        icon: MyIcons.delete,
        onPressed: (context) async {
          await openDialog(
            context,
            (context) => const MyDialog(
              title: 'Delete Post?',
              body: "Confirm that you want to delete this post",
              actions: ['Cancel', 'Delete'],
              destructive: 'Delete',
            ),
            dismissible: true,
          ).then((response) {
            if (response == 'Delete') {
              Navigator.pop(context);
              post.delete(context, onDelete);
            }
          });
        });

    List<Option> options = post.user.id == userProvider.user.id
        ? [download, edit, delete]
        : [notification, download, notInterested, block, report];

    return Options(options, share: true, shareText: 'post');
  }
}
