import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/data/posts.dart';
import 'package:pulsar/models/discover_tags.dart';
import 'package:pulsar/secondary_pages.dart/post_screen.dart';
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

  List<Post> posts = allPosts;

  String category = 'For you';

  String dataCategory = '';

  List<Map<String, dynamic>> data = [];

  Future<List<Map<String, dynamic>>> fetchData(int index) async {
    String storedCategory = category;
    await Future.delayed(const Duration(seconds: 2));
    List<Map<String, dynamic>> postResults = [...posts.map((e) => e.toJson())];
    postResults.shuffle();
    dataCategory = storedCategory;
    return postResults;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: RecyclerView(
            target: fetchData,
            itemBuilder: (context, snapshot) {
              List<Map<String, dynamic>> snapshotData = snapshot.data;
              if (dataCategory == category) data = [...snapshotData];
              List<Post> postData = [...data.map((e) => Post.fromJson(e))];

              return Column(
                children: [
                  DiscoverTags(
                      selected: category,
                      onChanged: (String value) {
                        setState(() {
                          category = value;
                          snapshot.refreshCallback();
                        });
                      }),
                  Flexible(
                      child: data.isEmpty
                          ? snapshot.errorLoading
                              ? Text('${snapshot.error} $data')
                              : const Center(child: MyProgressIndicator())
                          : dataCategory != category
                              ? const Center(child: MyProgressIndicator())
                              : RefreshIndicator(
                                  onRefresh: snapshot.refreshCallback,
                                  triggerMode:
                                      RefreshIndicatorTriggerMode.anywhere,
                                  child: GridView.builder(
                                      itemCount: data.length,
                                      padding: EdgeInsets.fromLTRB(
                                          8,
                                          0,
                                          8,
                                          MediaQuery.of(context)
                                              .padding
                                              .bottom),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.75,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8),
                                      itemBuilder: (context, index) {
                                        Post post = postData[index];
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
                                                          title: category,
                                                          postInView: index,
                                                        )));
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(9.5),
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              fit: StackFit.loose,
                                              children: [
                                                Positioned.fill(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .inputDecorationTheme
                                                          .fillColor,
                                                      image: DecorationImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                                  post.thumbnail
                                                                      .thumbnail),
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
            }));
  }
}
