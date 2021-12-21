import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/ads/list_tile_ad.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

class FollowingPosts extends StatefulWidget {
  @override
  _FollowingPostsState createState() => _FollowingPostsState();
}

class _FollowingPostsState extends State<FollowingPosts> {
  late CarouselController controller;

  List<Map<String, dynamic>> users = [
    {'user': lynn, 'cover': 'assets/posts/martina lynn/thumb 6.png'},
    {'user': tahlia, 'cover': 'assets/posts/tahlia stanton/thumb 8.png'},
    {'user': kinjaz, 'cover': 'assets/posts/kinjaz/thumb 1.png'},
    {'user': evanna, 'cover': 'assets/posts/evanna/thumb 2.png'},
  ];

  @override
  void initState() {
    super.initState();
    users.shuffle();
    controller = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.width * 0.85;

    return SafeArea(
      child: SingleChildScrollView(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                'No posts',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 24),
                maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                'There are no posts to show you.\nFollow users or challenges to view their posts.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontSize: 16.5),
              ),
            ),
            Container(
                height: height,
                margin: EdgeInsets.symmetric(vertical: 12),
                child: CarouselSlider(
                  carouselController: controller,
                  options: CarouselOptions(
                    height: height,
                    viewportFraction: 0.6,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    initialPage: 0,
                  ),
                  items: users
                      .map((info) => DiscoverPeopleCard(
                            info,
                            onPinned: () {
                              controller.nextPage();
                            },
                          ))
                      .toList(),
                )),
            ListTileAd()
          ],
        ),
      )),
    );
  }
}

class DiscoverPeopleCard extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function onPinned;

  DiscoverPeopleCard(this.user, {required this.onPinned});

  @override
  _DiscoverPeopleCardState createState() => _DiscoverPeopleCardState();
}

class _DiscoverPeopleCardState extends State<DiscoverPeopleCard> {
  late User user;
  late String cover;

  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    user = widget.user['user'];
    cover = widget.user['cover'];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => ProfilePage(user)));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(widget.user['cover']))),
          child: Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfilePic(
                  user.profilePic,
                  radius: 30,
                  onMedia: true,
                ),
                SizedBox(height: 6),
                Text(
                  '${user.username}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 16.5),
                ),
                Text(
                  '${user.category}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontSize: 15, color: Colors.white70),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 2),
                  child: FollowButton(
                    height: 32,
                    width: double.infinity,
                    isFollowing: isFollowing,
                    border: Colors.white70,
                    onPressed: () {
                      setState(() {
                        isFollowing = !isFollowing;
                      });
                      if (isFollowing) widget.onPinned();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
