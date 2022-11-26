import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/secondary_pages.dart/post_screen.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';

class GridPosts extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function(int index) fetchData;
  final String title;
  final bool refreshing;
  const GridPosts(this.fetchData,
      {Key? key, required this.title, this.refreshing = false})
      : super(key: key);

  @override
  _GridPostsState createState() => _GridPostsState();
}

class _GridPostsState extends State<GridPosts>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<Map<String, dynamic>>> fetchPosts(int index) async {
    List<Map<String, dynamic>> _posts = await widget.fetchData(index);

    return _posts;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RecyclerView(
        target: fetchPosts,
        itemBuilder: (context, snapshot) {
          List<Map<String, dynamic>> snapshotData = snapshot.data;
          List<Post> posts = [...snapshotData.map((e) => Post.fromJson(e))];
          if (widget.refreshing) {
            debugPrint("Refreshing Grid");
            snapshot.refreshCallback();
          }
          return snapshotData.isEmpty
              ? snapshot.isLoading ?? true
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: MyProgressIndicator(),
                    )
                  : snapshot.errorLoading
                      ? snapshot.noData
                          ? const NoPosts()
                          : NetworkError(onRetry: snapshot.refreshCallback)
                      : Container()
              : LayoutBuilder(builder: (context, constraints) {
                  int cols = constraints.maxWidth > 1024
                      ? 5
                      : constraints.maxWidth > 720
                          ? 4
                          : 3;
                  return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      constraints: const BoxConstraints(minHeight: 100),
                      child: GridView.builder(
                          itemCount: posts.length,
                          physics: const ClampingScrollPhysics(),
                          padding:
                              MediaQuery.of(context).padding.copyWith(top: 0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.75,
                                  crossAxisCount: cols,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    settings:
                                        const RouteSettings(name: 'postView'),
                                    builder: (context) => PostScreen(
                                          initialPosts: posts,
                                          target: fetchPosts,
                                          title: widget.title,
                                          postInView: index,
                                        )));
                              },
                              child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              posts[index].thumbnail.photo(
                                                  context,
                                                  max: 'medium')),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(8))),
                            );
                          }));
                });
        });
  }
}
