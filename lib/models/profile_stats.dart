import 'package:flutter/material.dart';
import 'package:pulsar/functions/dynamic_count.dart';

class ProfileStats extends StatelessWidget {
  final int? posts;
  final void Function() postOnPressed;
  final int? pins;
  final void Function() pinsOnPressed;
  final bool isPin;

  const ProfileStats(
      {Key? key,
      required this.pins,
      required this.pinsOnPressed,
      required this.postOnPressed,
      required this.posts,
      this.isPin = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = MediaQuery.of(context).size.width * 0.75;
      double padding = (constraints.maxWidth - width) / 2;
      return Card(
        elevation: 7,
        margin: EdgeInsets.symmetric(horizontal: padding, vertical: 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          padding: const EdgeInsets.all(5),
          height: 63,
          constraints: const BoxConstraints(maxWidth: 640),
          child: Row(children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: postOnPressed,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(posts == null ? ' - ' : roundCount(posts!),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 21)),
                    Text('Post${posts == 1 ? '' : 's'}',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontSize: 16.5))
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: VerticalDivider(),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: pinsOnPressed,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(pins == null ? ' - ' : roundCount(pins!),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 21)),
                    Text((isPin ? 'Pin' : 'Follower') + (pins == 1 ? '' : 's'),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontSize: 16.5))
                  ],
                ),
              ),
            ),
          ]),
        ),
      );
    });
  }
}
