import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/ads/grid_ad.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/data/posts.dart';
import 'package:pulsar/models/discover_tags.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/post_screen.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/home.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';

class DiscoverPosts extends StatefulWidget {
  const DiscoverPosts({Key? key}) : super(key: key);

  @override
  _DiscoverPostsState createState() => _DiscoverPostsState();
}

class _DiscoverPostsState extends State<DiscoverPosts>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late UserProvider userProvider;

  List<Post> posts = allPosts;

  String tag = 'For you';

  String dataTag = '';

  List<Map<String, dynamic>> data = [];

  Future<List<Map<String, dynamic>>> fetchData(int index) async {
    String storedTag = tag;
    List<Map<String, dynamic>> result = [];
    String url = getUrl(HomeUrls.discover(tag, index));

    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": userProvider.user.token ?? ""});

    var responseData = jsonDecode(response.body);

    if (responseData is Map && tag == storedTag) {
      result = [...responseData['posts']];
      dataTag = storedTag;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
        child: RecyclerView(
            target: fetchData,
            itemBuilder: (context, snapshot) {
              List<Map<String, dynamic>> snapshotData = snapshot.data;
              if (dataTag == tag) data = [...snapshotData];
              List<Post> postData = [...data.map((e) => Post.fromJson(e))];
              int ads = (postData.length / 12).round();
              int dataLength = postData.length + ads;
              int visibleAds = 0;
              return LayoutBuilder(builder: (context, constraints) {
                int cols = constraints.maxWidth > 1024
                    ? 4
                    : constraints.maxWidth > 720
                        ? 3
                        : 2;
                return Column(
                  children: [
                    DiscoverTags(
                        selected: tag,
                        onChanged: (String value) {
                          setState(() {
                            tag = value;
                            snapshot.refreshCallback();
                          });
                        }),
                    Flexible(
                        child: data.isEmpty
                            ? snapshot.errorLoading
                                ? snapshot.error == ApiError.connection
                                    ? NetworkError(
                                        onRetry: snapshot.refreshCallback)
                                    : const NoPosts(alignment: Alignment.center)
                                : const Center(child: MyProgressIndicator())
                            : dataTag != tag
                                ? const Center(child: MyProgressIndicator())
                                : RefreshIndicator(
                                    onRefresh: snapshot.refreshCallback,
                                    triggerMode:
                                        RefreshIndicatorTriggerMode.anywhere,
                                    child: GridView.builder(
                                        itemCount: dataLength,
                                        padding: EdgeInsets.fromLTRB(
                                            6,
                                            0,
                                            6,
                                            MediaQuery.of(context)
                                                .padding
                                                .bottom),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: cols,
                                                childAspectRatio: 0.75,
                                                crossAxisSpacing: 6,
                                                mainAxisSpacing: 6),
                                        itemBuilder: (context, index) {
                                          if (index == 0) visibleAds = 0;
                                          if ((index + 1) % 12 == 6 &&
                                              visibleAds < ads) {
                                            visibleAds++;
                                            return const GridAd();
                                          }
                                          Post post =
                                              postData[index - visibleAds];

                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      settings:
                                                          const RouteSettings(
                                                              name: 'postView'),
                                                      builder: (context) =>
                                                          PostScreen(
                                                            initialPosts:
                                                                postData,
                                                            title: tag,
                                                            postInView: index,
                                                          )));
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                fit: StackFit.loose,
                                                children: [
                                                  Positioned.fill(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .inputDecorationTheme
                                                            .fillColor,
                                                        image: DecorationImage(
                                                            image: CachedNetworkImageProvider(post
                                                                .thumbnail
                                                                .photo(context,
                                                                    max:
                                                                        'medium')),
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  )),
                  ],
                );
              });
            }));
  }
}
