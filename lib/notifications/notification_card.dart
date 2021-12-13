import 'package:flutter/material.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

class InteractionNotificationCard extends StatefulWidget {
  final User user;
  final Post? post;
  final Interaction type;
  InteractionNotificationCard(this.user, {required this.type, this.post});

  @override
  _InteractionNotificationCardState createState() =>
      _InteractionNotificationCardState();
}

class _InteractionNotificationCardState
    extends State<InteractionNotificationCard> {
  late User user;
  Post? post;
  late Interaction type;
  bool isFollowing = false;

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
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: openUser,
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: ProfilePic(
                  user.profilePic,
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
                        padding: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              '@${user.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontSize: 16.5),
                            ),
                            SizedBox(width: 10),
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
            SizedBox(width: 15),
            if (type == Interaction.follow)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: FollowButton(
                  height: 30,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  isFollowing: isFollowing,
                  onPressed: () {
                    setState(() {
                      isFollowing = !isFollowing;
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
                    borderRadius: BorderRadius.circular(5)),
              )
          ],
        ));
  }
}

enum Interaction { like, follow, comment, repost }
