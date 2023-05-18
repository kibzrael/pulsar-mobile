import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/placeholders/not_implemented.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/section.dart';
import 'package:share_plus/share_plus.dart';

class Options extends StatelessWidget {
  final List<Option> options;
  final bool share;
  final String shareText;

  const Options(this.options,
      {Key? key, required this.share, this.shareText = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Option message = Option(
        name: local(context).message,
        icon: MyIcons.send,
        color: Theme.of(context).colorScheme.primary,
        onPressed: (context) {
          toastNotImplemented();
          // Navigator.of(context)
          //     .push(myPageRoute(builder: (context) => const ComposeMessage()));
        });

    Option link = Option(
        name: local(context).copyLink,
        icon: MyIcons.link,
        color: Theme.of(context).colorScheme.primary,
        onPressed: (context) {
          Clipboard.setData(ClipboardData(text: '$shareText on Pulsar.'));
          Fluttertoast.showToast(
              msg: 'Link Copied to clipboard.', gravity: ToastGravity.BOTTOM);
        });

    Option more = Option(
        name: local(context).more,
        icon: MyIcons.more,
        color: Theme.of(context).colorScheme.primary,
        onPressed: (context) {
          Share.share('Check out this $shareText on Pulsar.');
        });

    return MyBottomSheet(
      title: share
          ? Section(
              title: 'Share${shareText != '' ? ' ' : ''}$shareText with:',
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
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
        height: 120,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const BouncingScrollPhysics(),
          children: [
            for (Option option in options) OptionLayout(option, share: false)
          ],
        ),
      ),
    );
  }
}

class OptionLayout extends StatelessWidget {
  final Option option;
  final bool share;

  const OptionLayout(this.option, {Key? key, this.share = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 30) / (share ? 3 : 4);
    double margin = share ? 24 : 18;
    return InkWell(
      onTap: () {
        option.onPressed(context);
      },
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: margin, vertical: 8),
              elevation: 4,
              shape: const CircleBorder(),
              child: Container(
                height: width - (margin * 2),
                alignment: Alignment.center,
                child: Icon(
                  option.icon,
                  size: share ? 30 : 27,
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
                  .titleSmall!
                  .copyWith(fontSize: share ? 15 : 13.5, color: option.color),
            )
          ],
        ),
      ),
    );
  }
}
