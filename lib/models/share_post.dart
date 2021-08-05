import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/section.dart';

class SharePost extends StatefulWidget {
  @override
  _SharePostState createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  @override
  Widget build(BuildContext context) {
    Option message = Option(
        name: 'Message',
        icon: MyIcons.send,
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {});

    Option link = Option(
        name: 'Copy link',
        icon: MyIcons.link,
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {});

    Option more = Option(
        name: 'More',
        icon: MyIcons.more,
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {});

    Option notification = Option(
        name: 'Post Notifications',
        icon: MyIcons.notifications,
        onPressed: () {});
    Option block = Option(
        name: 'Block',
        icon: MyIcons.block,
        color: Theme.of(context).colorScheme.error,
        onPressed: () {});
    Option report = Option(
        name: 'Report',
        icon: MyIcons.report,
        color: Theme.of(context).colorScheme.error,
        onPressed: () {});

    Option download =
        Option(name: 'Download', icon: MyIcons.download, onPressed: () {});

    return MyBottomSheet(
      title: Section(
        title: 'Share with:',
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              15, 2, 15, 12), //  symmetric(horizontal: 15, vertical: 12),
          child: Row(
            children: [
              OptionLayout(message),
              OptionLayout(link),
              OptionLayout(more),
            ],
          ),
        ),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Wrap(
          children: [
            OptionLayout(notification),
            OptionLayout(block),
            OptionLayout(report),
            OptionLayout(download),
          ],
        ),
      ),
    );
  }
}

class OptionLayout extends StatelessWidget {
  final Option option;

  OptionLayout(this.option);

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 30) / 3;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            elevation: 4,
            shape: CircleBorder(),
            child: Container(
              height: width - 48,
              alignment: Alignment.center,
              child: Icon(
                option.icon,
                size: 30,
                color: option.color,
              ),
            ),
          ),
          Text(
            option.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(fontSize: 15, color: option.color),
          )
        ],
      ),
    );
  }
}
