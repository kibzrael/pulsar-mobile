import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/ads/list_tile_ad.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/providers/theme_provider.dart';
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
  State<DiscoverUsers> createState() => _DiscoverUsersState();
}

class _DiscoverUsersState extends State<DiscoverUsers>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late UserProvider userProvider;

  late CarouselController controller;

  @override
  void initState() {
    super.initState();
    controller = CarouselController();
  }

  Future<List<Map<String, dynamic>>> fetchUsers(int index) async {
    List<Map<String, dynamic>> results = [];
    String url = getUrl(HomeUrls.discoverUsers(index));

    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": userProvider.user.token ?? ""});

    var responseData = jsonDecode(response.body);

    if (responseData is Map) {
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
                    .titleLarge!
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
                    .titleSmall!
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
                              ? snapshot.noData
                                  ? const NoPostsModel()
                                  : NetworkErrorModel(
                                      onRetry: snapshot.refreshCallback)
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
                                          // 'cover': kinjaz1.thumbnail.thumbnail
                                        },
                                        onPinned: () {
                                          controller.nextPage();
                                        },
                                      ))
                                  .toList(),
                            );
                    })),
            const ListTileAd(dark: true)
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
  State<DiscoverUsersCard> createState() => _DiscoverUsersCardState();
}

class _DiscoverUsersCardState extends State<DiscoverUsersCard> {
  late InteractionsSync interactionSync;

  late User user;

  bool get isFollowing => interactionSync.isFollowing(user);

  @override
  void initState() {
    super.initState();
    user = widget.user['user'];
  }

  @override
  Widget build(BuildContext context) {
    interactionSync = Provider.of<InteractionsSync>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => ProfilePage(user)));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      lightTheme.textTheme.displayLarge!.color!,
                      lightTheme.textTheme.titleLarge!.color!,
                    ]),
                image: user.profilePic == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            user.profilePic!.thumbnail))),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.4, sigmaY: 2.4),
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
                          .titleLarge!
                          .copyWith(fontSize: 16.5, color: Colors.white),
                    ),
                    Text(
                      user.category,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
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
                                    : RequestMethod.post,
                                onNotify: () => setState(() {}));
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
        ),
      ),
    );
  }
}
