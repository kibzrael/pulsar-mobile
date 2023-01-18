import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/activity.dart';
import 'package:pulsar/functions/time.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/profile_pic.dart';

class InteractionNotificationCard extends StatefulWidget {
  final InteractionActivity activity;
  const InteractionNotificationCard(this.activity, {Key? key})
      : super(key: key);

  @override
  _InteractionNotificationCardState createState() =>
      _InteractionNotificationCardState();
}

class _InteractionNotificationCardState
    extends State<InteractionNotificationCard> {
  late InteractionsSync interactionsSync;

  late InteractionActivity activity;

  // TODO:Implement following
  bool get isFollowing => false; //interactionsSync.isFollowing(user);

  @override
  void initState() {
    super.initState();
    activity = widget.activity;
  }

  @override
  Widget build(BuildContext context) {
    interactionsSync = Provider.of<InteractionsSync>(context);
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ProfilePic(
                  activity.thumbnail,
                  radius: 24,
                ),
              ),
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              '@${activity.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontSize: 16.5),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              timeAgo(activity.time),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!['', null].contains(activity.description))
                      Text(
                        activity.description!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                  ]),
            ),
            const SizedBox(width: 15),
            if (activity.type == Interaction.follow)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: FollowButton(
                  height: 30,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  isFollowing: isFollowing,
                  onPressed: () {
                    setState(() {
                      // user.follow(context,
                      //     mode: isFollowing
                      //         ? RequestMethod.delete
                      //         : RequestMethod.post,
                      //     onNotify: () => setState(() {}));
                    });
                  },
                ),
              )
            else if (!['', null].contains(activity.media))
              Container(
                width: 60,
                height: activity.type == Interaction.comment ? 75 : 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(original.convolution),
                  // TODO:Implement post filter
                  // colorFilter:
                  //     ColorFilter.matrix(getFilter(post?.filter).convolution),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: NetworkImage('${activity.media}'),
                            fit: BoxFit.cover)),
                  ),
                ),
              )
          ],
        ));
  }
}
