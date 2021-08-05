import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/posts.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/secondary_pages.dart/post_screen.dart';

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
    BasicRootProvider? basicRootProvider;
    double bottomPadding = 0;

    try {
      basicRootProvider = Provider.of<BasicRootProvider>(context);
    } on Exception {}
    if (basicRootProvider != null) {
      bottomPadding = kToolbarHeight;
    }

    return isLoading
        ? Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 100,
              width: 100,
              child: SpinKitCircle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[350]
                    : Colors.white54,
              ),
            ),
          )
        : posts.isEmpty
            ? NoPosts()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                constraints: BoxConstraints(minHeight: 100),
                child: GridView.builder(
                    itemCount: posts.length,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomPadding),
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
                                    image: AssetImage(
                                        posts[index].video.thumbnail),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(8))),
                      );
                    }));
  }
}
