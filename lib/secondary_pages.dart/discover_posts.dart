import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/data/posts.dart';
import 'package:pulsar/models/discover_tags.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/secondary_pages.dart/post_screen.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';

class DiscoverPosts extends StatefulWidget {
  const DiscoverPosts({Key? key}) : super(key: key);

  @override
  _DiscoverPostsState createState() => _DiscoverPostsState();
}

class _DiscoverPostsState extends State<DiscoverPosts> {
  List<Post> posts = allPosts;

  String category = 'For you';

  String dataCategory = '';

  List<Map<String, dynamic>> data = [];

  Future<List<Map<String, dynamic>>> fetchData(int index) async {
    String storedCategory = '$category';
    await Future.delayed(Duration(seconds: 2));
    List<Map<String, dynamic>> postResults = [
      ...posts.map((e) => e.toJson(context))
    ];
    postResults.shuffle();
    dataCategory = storedCategory;
    return postResults;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: RecyclerView(
            target: fetchData,
            itemBuilder: (context, snapshot) {
              List<Map<String, dynamic>> snapshotData = snapshot.data;
              if (dataCategory == category) data = [...snapshotData];
              List<Post> postData = [...data.map((e) => Post.fromJson(e))];
              if (snapshot.errorLoading) print(snapshot.error);

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
                              : Center(child: MyProgressIndicator())
                          : dataCategory != category
                              ? Center(child: MyProgressIndicator())
                              : RefreshIndicator(
                                  onRefresh: snapshot.refreshCallback,
                                  triggerMode:
                                      RefreshIndicatorTriggerMode.anywhere,
                                  child: GridView.builder(
                                      itemCount: data.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.75,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5),
                                      itemBuilder: (context, index) {
                                        Post post = postData[index];
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    settings: RouteSettings(
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
                                                BorderRadius.circular(6),
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
                                                          image: AssetImage(post
                                                              .video.thumbnail),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                ),
                                                Theme(
                                                  data: darkTheme,
                                                  child: Builder(
                                                      builder: (context) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      height: 50,
                                                      child: Row(
                                                        children: [
                                                          ProfilePic(
                                                            post.user
                                                                .profilePic,
                                                            radius: 18,
                                                            onMedia: true,
                                                          ),
                                                          SizedBox(width: 2.5),
                                                          Expanded(
                                                              child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  '@${post.user.username}',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle1!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              13)),
                                                              Text('${post.user.category}',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle2!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white))
                                                            ],
                                                          )),
                                                          SizedBox(width: 2.5),
                                                          Icon(MyIcons.play,
                                                              size: 18),
                                                          Text('2.4K',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle2!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white))
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                )
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
