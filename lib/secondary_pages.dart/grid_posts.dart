import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/posts.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/secondary_pages.dart/post_screen.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

class GridPosts extends StatefulWidget {
  final User user;
  GridPosts(this.user);

  @override
  _GridPostsState createState() => _GridPostsState();
}

class _GridPostsState extends State<GridPosts>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = true;

  late User user;

  List<Post> posts = [];

  fetchPosts() async {
    await Future.delayed(Duration(seconds: 2));

    List<Post> _posts =
        allPosts.where((element) => element.user.id == user.id).toList();

    if (mounted)
      setState(() {
        posts = [...posts, ..._posts];
        isLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return isLoading
        ? Align(
            alignment: Alignment.topCenter,
            child: MyProgressIndicator(),
          )
        : posts.isEmpty
            ? NoPosts()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                constraints: BoxConstraints(minHeight: 100),
                child: GridView.builder(
                    itemCount: posts.length,
                    physics: ClampingScrollPhysics(),
                    padding: MediaQuery.of(context).padding.copyWith(top: 0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.75,
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              settings: RouteSettings(name: 'postView'),
                              builder: (context) => PostScreen(
                                    initialPosts: posts,
                                    title: '@${user.username}',
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
                                        posts[index].video.thumbnail),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(8))),
                      );
                    }));
  }
}
