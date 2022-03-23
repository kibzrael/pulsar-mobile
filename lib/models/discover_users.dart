import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/ads/list_tile_ad.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/posts.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/home.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/route.dart';

class DiscoverUsers extends StatefulWidget {
  const DiscoverUsers({Key? key}) : super(key: key);

  @override
  _DiscoverUsersState createState() => _DiscoverUsersState();
}

class _DiscoverUsersState extends State<DiscoverUsers>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late UserProvider userProvider;

  late CarouselController controller;

  List<Map<String, dynamic>> users = [
    {'user': lynn, 'cover': lynn6.thumbnail.thumbnail},
    {'user': tahlia, 'cover': tahlia8.thumbnail.thumbnail},
    {'user': kinjaz, 'cover': kinjaz1.thumbnail.thumbnail},
    {'user': evanna, 'cover': evanna2.thumbnail.thumbnail},
  ];

  @override
  void initState() {
    super.initState();
    users.shuffle();
    controller = CarouselController();
  }

  Future<List<Map<String, dynamic>>> fetchUsers(int index) async {
    List<Map<String, dynamic>> results = [];
    String url = getUrl(HomeUrls.discoverUsers);

    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": userProvider.user.token ?? ""});

    var responseData = jsonDecode(response.body);

    if (responseData is Map) {
      print(responseData['users']);
      results = [...responseData['users']];
    }
    return results;
  }

  Future onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    userProvider = Provider.of<UserProvider>(context);
    double height = MediaQuery.of(context).size.width * 0.85;
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
                'No Posts',
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
                    bufferExtent: 0.75,
                    itemBuilder: (context, snapshot) {
                      List<Map<String, dynamic>> snapshotData = snapshot.data;
                      return snapshotData.isEmpty
                          ? snapshot.errorLoading
                              ? const NetworkError()
                              : const Center(child: MyProgressIndicator())
                          : CarouselSlider(
                              carouselController: controller,
                              options: CarouselOptions(
                                  height: height,
                                  viewportFraction: 0.6,
                                  enableInfiniteScroll: false,
                                  enlargeCenterPage: true,
                                  initialPage: 0,
                                  onPageChanged: (index, _) {
                                    snapshot.onPageChanged(
                                        snapshotData.length - index);
                                  }),
                              items: snapshotData
                                  .map((info) => DiscoverUsersCard(
                                        {
                                          'user': User.fromJson(info),
                                          'cover': kinjaz1.thumbnail.thumbnail
                                        },
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

class DiscoverUsersCard extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function onPinned;

  const DiscoverUsersCard(this.user, {Key? key, required this.onPinned})
      : super(key: key);

  @override
  _DiscoverUsersCardState createState() => _DiscoverUsersCardState();
}

class _DiscoverUsersCardState extends State<DiscoverUsersCard> {
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
                      .copyWith(fontSize: 16.5, color: Colors.white),
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
                        user.follow(context,
                            mode: isFollowing
                                ? RequestMethod.delete
                                : RequestMethod.post);
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
