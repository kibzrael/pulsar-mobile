import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/ads/list_tile_ad.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/posts.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/providers/connectivity_provider.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/route.dart';

class FollowingPosts extends StatefulWidget {
  const FollowingPosts({Key? key}) : super(key: key);

  @override
  _FollowingPostsState createState() => _FollowingPostsState();
}

class _FollowingPostsState extends State<FollowingPosts> {
  late CarouselController controller;

  List<Map<String, dynamic>> users = [
    {'user': lynn, 'cover': lynn6.thumbnail.photo},
    {'user': tahlia, 'cover': tahlia8.thumbnail.photo},
    {'user': kinjaz, 'cover': kinjaz1.thumbnail.photo},
    {'user': evanna, 'cover': evanna2.thumbnail.photo},
  ];

  @override
  void initState() {
    super.initState();
    users.shuffle();
    controller = CarouselController();
  }

  Future<List<Map<String, dynamic>>> fetchUsers(int index) async {
    List<Map<String, dynamic>> results = [...users];
    if (index != 0) await Future.delayed(const Duration(seconds: 2));
    return results;
  }

  Future onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.width * 0.85;
    ConnectivityResult? connectivity =
        Provider.of<ConnectivityProvider>(context).connectivity;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                '${connectivity?.name}',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 24),
                maxLines: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: RecyclerView(
                    target: fetchUsers,
                    itemBuilder: (context, snapshot) {
                      List<Map<String, dynamic>> snapshotData = snapshot.data;
                      return snapshotData.isEmpty
                          ? const Center(
                              child: Text('Error loading!'),
                            )
                          : CarouselSlider(
                              carouselController: controller,
                              options: CarouselOptions(
                                height: height,
                                viewportFraction: 0.6,
                                enableInfiniteScroll: false,
                                enlargeCenterPage: true,
                                initialPage: 0,
                              ),
                              items: snapshotData
                                  .map((info) => DiscoverPeopleCard(
                                        info,
                                        onPinned: () {
                                          controller.nextPage();
                                        },
                                      ))
                                  .toList(),
                            );
                    })),
            const ListTileAd()
          ],
        )),
      ),
    );
  }
}

class DiscoverPeopleCard extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function onPinned;

  const DiscoverPeopleCard(this.user, {Key? key, required this.onPinned})
      : super(key: key);

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
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfilePic(
                  user.profilePic?.thumbnail,
                  radius: 30,
                  onMedia: true,
                ),
                const SizedBox(height: 6),
                Text(
                  user.username,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 16.5),
                ),
                Text(
                  user.category ?? 'Personal Account',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontSize: 15, color: Colors.white70),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
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
