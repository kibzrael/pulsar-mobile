import 'package:flutter/material.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/models/profile_stats.dart';
import 'package:pulsar/secondary_pages.dart/interaction_screen.dart';
import 'package:pulsar/secondary_pages.dart/photo_view.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

class Profile extends StatefulWidget {
  final User user;
  final ScrollController scrollController;
  Profile(this.user, {required this.scrollController});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isPinned = false;

  late User user;

  @override
  void initState() {
    user = widget.user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: InkWell(
                    onTap: () {
                      if (user.profilePic != null)
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => PhotoView(
                                    user.profilePic!,
                                    tag: '${user.id}ProfilePic')));
                    },
                    child: HeroMode(
                      enabled: true,
                      child: Hero(
                          tag: '${user.id}ProfilePic',
                          child: ProfilePic(user.profilePic, radius: 60)),
                    )

                    // MyAvatar(user.profilePic, 45.0)
                    ),
              ),
              Text(
                '${user.username}',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 21),
              ),
              Text(
                '${user.category}',
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
            pins: 53730,
            pinsOnPressed: () {
              Navigator.of(context).push(myPageRoute(
                  builder: (context) => InteractionScreen(
                        user: user,
                      )));
            },
            postOnPressed: () {
              widget.scrollController.animateTo(
                  widget.scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 700),
                  curve: Curves.ease);
            },
            posts: 7),
        //if (user.bio != null)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            'It\'s just love\n@fletcher',
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 5),
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 5),
        //   alignment: Alignment.center,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       LinkedAccountLabel(
        //         colors: [Colors.blue[900]!, Colors.blue[900]!],
        //         icon: MyIcons.facebook,
        //         user: '@rael',
        //       ),
        //       LinkedAccountLabel(colors: [
        //         Colors.deepPurpleAccent,
        //         Colors.orangeAccent,
        //       ], icon: MyIcons.instagram, user: '@kibzrael'),
        //       LinkedAccountLabel(
        //         colors: [Colors.blue, Colors.blue],
        //         icon: MyIcons.twitter,
        //         user: '@kibzrael',
        //       ),
        //     ],
        //   ),
        // ),
        // //if (user.portfolio != null)
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 5),
        //   child: Text(
        //     'https://www.mefletcher.com',
        //     style:
        //         TextStyle(color: Theme.of(context).buttonColor, fontSize: 14),
        //     overflow: TextOverflow.ellipsis,
        //   ),
        // ),
      ]),
    );
  }
}

class LinkedAccountLabel extends StatelessWidget {
  final IconData icon;
  final String user;
  final List<Color> colors;
  LinkedAccountLabel({
    required this.colors,
    required this.icon,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: CircleBorder(),
      elevation: 3,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.all(8.0),
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
