import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/models/profile_stats.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/secondary_pages.dart/interaction_screen.dart';
import 'package:pulsar/secondary_pages.dart/photo_view.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final User user;
  final ScrollController scrollController;
  const Profile(this.user, {Key? key, required this.scrollController})
      : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isPinned = false;

  late User user;

  @override
  Widget build(BuildContext context) {
    user = widget.user;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: InkWell(
                    onTap: () {
                      if (user.profilePic != null) {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => PhotoView(
                                    user.profilePic!.photo(context),
                                    tag: '${user.id}ProfilePic')));
                      }
                    },
                    child: HeroMode(
                      enabled: true,
                      child: Hero(
                          tag: '${user.id}ProfilePic',
                          child: ProfilePic(
                              user.profilePic?.photo(context, max: 'medium'),
                              radius: 60)),
                    )

                    // MyAvatar(user.profilePic, 45.0)
                    ),
              ),
              Text(
                user.fullname ?? user.username,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 21),
              ),
              Text(
                user.category,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
        ProfileStats(
            pins: user.followers,
            pinsOnPressed: () {
              Navigator.of(context).push(myPageRoute(
                  builder: (context) => InteractionScreen(
                        user: user,
                        value: user.followers,
                      )));
            },
            postOnPressed: () {
              widget.scrollController.animateTo(
                  widget.scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.ease);
            },
            posts: user.posts),
        if (user.bio != null && user.bio != '')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              user.bio!,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        const SizedBox(height: 5),
        if (user.portfolio != null && user.portfolio != '')
          InkWell(
            onTap: () async {
              Uri url = Uri.parse(user.portfolio!);
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                Fluttertoast.showToast(msg: 'Could not launch $url');
              }
            },
            child: ShaderMask(
              shaderCallback: (rect) => primaryGradient().createShader(rect),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MyIcons.link,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      user.portfolio!,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ]),
    );
  }
}

class LinkedAccountLabel extends StatelessWidget {
  final IconData icon;
  final String user;
  final List<Color> colors;
  const LinkedAccountLabel({
    Key? key,
    required this.colors,
    required this.icon,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const CircleBorder(),
      elevation: 3,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                .createShader(rect);
          },
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );

    // Row(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Icon(icon, color: color, size: 18),
    //     SizedBox(width: 4),
    //     Text(
    //       user,
    //       style: TextStyle(color: color),
    //     )
    //   ],
    // );
  }
}
