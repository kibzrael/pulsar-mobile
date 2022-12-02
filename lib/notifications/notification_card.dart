import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

class InteractionNotificationCard extends StatefulWidget {
  final User user;
  final Post? post;
  final Interaction type;
  const InteractionNotificationCard(this.user,
      {Key? key, required this.type, this.post})
      : super(key: key);

  @override
  _InteractionNotificationCardState createState() =>
      _InteractionNotificationCardState();
}

class _InteractionNotificationCardState
    extends State<InteractionNotificationCard> {
  late InteractionsSync interactionsSync;

  late User user;
  Post? post;
  late Interaction type;
  bool get isFollowing => interactionsSync.isFollowing(user);

  @override
  void initState() {
    super.initState();
    user = widget.user;
    post = widget.post;
    type = widget.type;
  }

  openUser() {
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => ProfilePage(user)));
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
              onTap: openUser,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ProfilePic(
                  user.profilePic?.thumbnail,
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
                      onTap: openUser,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              '@${user.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontSize: 16.5),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Yesterday',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      type == Interaction.follow
                          ? 'Followed you'
                          : type == Interaction.like
                              ? "Liked your post"
                              : type == Interaction.repost
                                  ? "Reposted your post"
                                  : "Commmented on your post:\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." //comment
                      ,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ]),
            ),
            const SizedBox(width: 15),
            if (type == Interaction.follow)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: FollowButton(
                  height: 30,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  isFollowing: isFollowing,
                  onPressed: () {
                    setState(() {
                      user.follow(context,
                          mode: isFollowing
                              ? RequestMethod.delete
                              : RequestMethod.post,
                          onNotify: () => setState(() {}));
                    });
                  },
                ),
              )
            else
              Container(
                width: 60,
                height: type == Interaction.comment ? 75 : 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.matrix(getFilter(post?.filter).convolution),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              )
          ],
        ));
  }
}

enum Interaction { like, follow, comment, repost }
