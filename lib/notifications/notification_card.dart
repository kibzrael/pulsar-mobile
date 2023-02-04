import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/activity.dart';
import 'package:pulsar/classes/user.dart';
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
  State<InteractionNotificationCard> createState() =>
      _InteractionNotificationCardState();
}

class _InteractionNotificationCardState
    extends State<InteractionNotificationCard> {
  late InteractionsSync interactionsSync;

  late InteractionActivity activity;

  bool get isFollowing => interactionsSync.isFollowing(activity.user);

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
        // margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        color: activity.read
            ? null
            : Theme.of(context).colorScheme.primary.withAlpha(30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ProfilePic(
                  activity.user.profilePic?.thumbnail,
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
                              '@${activity.user.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 16.5),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              timeAgo(activity.time),
                              style: Theme.of(context).textTheme.titleSmall,
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
                        style: Theme.of(context).textTheme.bodyMedium,
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
                      activity.user.follow(context,
                          mode: isFollowing
                              ? RequestMethod.delete
                              : RequestMethod.post,
                          onNotify: () => setState(() {}));
                    });
                  },
                ),
              )
            else if (activity.media != null)
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
                            image: NetworkImage(
                                activity.media!.photo(context, max: 'medium')),
                            fit: BoxFit.cover)),
                  ),
                ),
              )
          ],
        ));
  }
}
