import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/models/share_post.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/section.dart';

class Options extends StatelessWidget {
  final List<Option> options;
  final bool share;
  final String shareText;

  Options(this.options, {required this.share, this.shareText = ''});

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

    return MyBottomSheet(
      title: share
          ? Section(
              title: 'Share${shareText != '' ? ' ' : ''}$shareText with:',
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
            )
          : null,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Wrap(
          children: [for (Option option in options) OptionLayout(option)],
        ),
      ),
    );
  }
}
